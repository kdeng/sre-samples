"""
BigQuery Ingestion handler for all URLs
"""
import gc
import os
import json
import sys
import logging
import webapp2
import cloudstorage as gcs
from google.appengine.api import app_identity
from google.cloud import bigquery

# Define logger
FORMAT = '%(asctime)s (%(processName)s) [%(name)s] %(levelname)s - %(message)s'
logging.basicConfig(format=FORMAT)
_LOGGER = logging.getLogger('MAIN')
_LOGGER.setLevel(logging.INFO)

# Current Project ID
GAE_APP_ID = app_identity.get_application_id()

# Current Work Directory
CURRENT_DIR = os.path.dirname(os.path.realpath(__file__))

# Service Acount Key
SERVICE_ACCOUNT_KEY_JSON = CURRENT_DIR + "/service-account.json"


# BigQuery Load Job handler
class BigQueryLoadJobHandler(webapp2.RequestHandler):
    """
    A task queue handler to submit a new BigQuery load job.
    This handler only accept the request in POST method.
    The payload should contain three variables as a FORM data.
    :param gcs_filename
    :param dataset_id is the destination dataset ID
    :param table_id is the destination table ID

    """

    def post(self):
        """
        POST method handler
        """
        self.response.headers['Content-Type'] = 'text/plain'

        gcs_filename = self.request.POST.get('gcs_filename')
        dest_dataset_id = self.request.POST.get('dataset_id')
        dest_table_id = self.request.POST.get('table_id')
        _LOGGER.info("Received a request to load '%s' into destination table `%s.%s.%s`" % (gcs_filename, GAE_APP_ID, dest_dataset_id, dest_table_id))

        if not (gcs_filename or dest_dataset_id or dest_table_id):
            _LOGGER.error("Cannot process this request as one of 'gcs_filename', 'dataset_id', 'table_id' is missing")
            # Send response
            self.response.write('Bad request')
            self.response.set_status(400)
            return

        if not self._is_gcs_file_existing(gcs_filename):
            _LOGGER.warning("Ignore this request because GCS File '%s' doesn't exist" % gcs_filename)
            # Send response
            self.response.write('Bad request')
            self.response.set_status(400)
            return

        if self._has_already_ingested(gcs_filename):
            _LOGGER.warning("This report '%s' already be loaded, and ignore this request" % gcs_filename)
            # send Not content response
            self.response.write('No Content')
            self.response.set_status(204)
            return

        try:

            # Batch load data from GCS
            big_query_client = self._create_bigquery_client()
            job_config = self._create_bigquery_job_config()

            logger.info("Initialised a table reference")
            table_ref = big_query_client.dataset(dest_dataset_id).table(dest_table_id)

            # API request
            _LOGGER.info('Sending the BigQuery Load Job to load \'%s\'' % gcs_filename)
            load_job = big_query_client.load_table_from_uri(gcs_filename, table_ref, job_config=job_config)
            load_job_id = load_job.job_id
            _LOGGER.info("Created a BigQuery load job in ID '%s' with status '%s'" % (load_job_id, load_job.job_type))

            # Log the job ID
            _LOGGER.info("Logging this job ID '%s'" % load_job_id)
            self._log_bigquery_job_id(gcs_filename, load_job_id)

            # Waiting for job to complete
            logger.info("Waiting for job to complete")
            load_job.result()  # Waits for table load to complete.
            logger.info("Batch load job completes successfully")
            _LOGGER.info("Loaded %s rows into BigQuery table '%s.%s'." % (load_job.output_rows, dest_dataset_id, dest_table_id))

            # Send response
            self.response.write('Created')
            self.response.set_status(201)

        except:
            _LOGGER.error("Unexpected error while processing the request : %s" % sys.exc_info())
            self.response.set_status(500)
            self.response.write('Internal Server Error')

        finally:
            cleaned_variable_number = gc.collect()
            _LOGGER.info("Collected %d variables from memory", cleaned_variable_number)
            logger.info("=============== DONE ===============")


    def _create_bigquery_client(self, service_account_json = SERVICE_ACCOUNT_KEY_JSON):
        """
        Instantiate a new BigQuery Client with service account
        """
        _LOGGER.info('Creating a new BigQuery client')
        return bigquery.Client.from_service_account_json(service_account_json)

    def _create_bigquery_job_config(self):
        """
        Create a new BigQuery job configuration based on current request
        """
        _LOGGER.info("Creating a new LoadJob configuration")
        new_job_config = bigquery.LoadJobConfig()

        gcs_source_format = self.request.POST.get('source_format')
        if not gcs_source_format:
            gcs_source_format = 'CSV'
        new_job_config.source_format = gcs_source_format
        _LOGGER.info('Report source format is %s' % gcs_source_format)

        if self.request.POST.get('autodetect') in ('False', 'false', 'FALSE'):
            do_autodetect = False
        else:
            do_autodetect = True

        serialised_table_schema = self.request.POST.get('schema')
        if serialised_table_schema and not do_autodetect:
            table_schema = json.loads(serialised_table_schema)

        new_job_config.skip_leading_rows = 1 # file has a header row

        if not do_autodetect:
            if table_schema:
                new_job_config.schema = json.loads(table_schema)
            else:
                do_autodetect = True
                logger.warning("Table schema is invalid, and update autodetect to be TRUE")

        new_job_config.autodetect = do_autodetect
        _LOGGER.info("Report schema autodetect is %d", do_autodetect)

        # If the table does not exist, BigQuery creates the table (even it is a default value)
        new_job_config.create_disposition = 'CREATE_IF_NEEDED'
        new_job_config.write_disposition = 'WRITE_APPEND'

        return new_job_config

    def _is_gcs_file_existing(self, gcs_filename):
        """
        Check whether GCS file exists or not
        :param gcs_filename should is a full path of GCS file path, and it should be gs://bucket_name/file_name
        :return True if gcs_filename is pointing a valid Google Bucket
        """
        try:
            return gcs.stat(gcs_filename[4:])
        except gcs.NotFoundError:
            return False

    def _log_bigquery_job_id(self, gcs_filename, job_id):
        """
        Log newly created BigQuery load job ID into a GCS file
        """
        _LOGGER.info("Saving BigQuery load job in ID '%s'", job_id)
        gcs_log_filname = self._generate_log_filename(gcs_filename)
        gcs_file = gcs.open(gcs_log_filname[4:], 'w', content_type='text/plain')
        gcs_file.write(job_id.encode("utf-8"))
        gcs_file.close()
        _LOGGER.info("Saved Job ID in log file '%s' successfully", gcs_log_filname)

    def _has_already_ingested(self, gcs_filename):
        """
        Check whether this report already be loaded into BigQuery Table or not.
        """
        _LOGGER.info("Checking whether this report already be loaded or not")
        return self._is_gcs_file_existing(self._generate_log_filename(gcs_filename))

    def _generate_log_filename(self, gcs_filename):
        """
        Generate a log filename for GCS based on report CSV filename
        """
        return "%s.log" % gcs_filename

app = webapp2.WSGIApplication([('/.*', BigQueryLoadJobHandler),], debug=True)


if __name__ == "__main__":
    from google.appengine.ext.webapp.util import run_wsgi_app
    run_wsgi_app(app)