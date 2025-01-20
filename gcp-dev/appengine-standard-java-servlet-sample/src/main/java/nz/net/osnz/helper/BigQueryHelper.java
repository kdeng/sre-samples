package nz.net.osnz.helper;

import com.google.cloud.bigquery.BigQuery;
import com.google.cloud.bigquery.BigQueryOptions;
import com.google.cloud.bigquery.CsvOptions;
import com.google.cloud.bigquery.Field;
import com.google.cloud.bigquery.Job;
import com.google.cloud.bigquery.JobInfo;
import com.google.cloud.bigquery.LegacySQLTypeName;
import com.google.cloud.bigquery.LoadJobConfiguration;
import com.google.cloud.bigquery.Schema;
import com.google.cloud.bigquery.TableId;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;

/**
 * @author Kefeng Deng (deng@51any.com)
 */
public class BigQueryHelper {


    private static final Logger LOG = LoggerFactory.getLogger(BigQueryHelper.class);

    /**
     * Returns the singleton instance of Bigquery, or instantiates one if it does not already exist.
     */
    private static BigQuery getBigQuery() {
        return BigQueryOptions.getDefaultInstance().getService();
    }

    /**
     * Generate schema for Adobe Data Feed table
     *
     * @return a {@code Schema} of Adobe Data Feed table
     */
    private static Schema generateSchema() {
        List<Field> schemaList = new ArrayList<>();
        schemaList.add(Field.newBuilder("report_date", LegacySQLTypeName.DATE).build());
        schemaList.add(Field.newBuilder("geo_country", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("geo_region", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("geo_city", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("visitor_id", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("visit_id", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("video_name", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("site", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("site_section", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("sub_section", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("user_server", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("mobile_id", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("content_id", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("video_source", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("video_length", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("source", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("author", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("event_list", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("is_visit", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("is_page_view", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("is_article_view", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("is_video_view", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("is_video_milestone_view", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("is_video_complete_view", LegacySQLTypeName.STRING).build());
        schemaList.add(Field.newBuilder("is_video_time_view", LegacySQLTypeName.STRING).build());
        return Schema.of(schemaList);
    }

    /**
     * Submit a LOAD job to big query
     *
     * @param gcsFilename is the GS file path
     * @param projectId is the project that dataset belongs to
     * @param datasetId is the dataset id
     * @param tableId is the table id
     * @return {@code Job} be created to load data into bigquery table
     */
    public static Job submitJob(String gcsFilename, String projectId, String datasetId, String tableId) {
        TableId tableRef = TableId.of(datasetId, tableId);
        // Set GCS path as a source
        String fullFilename = "gs://" + gcsFilename;
        LOG.info("Loading GCS source '{}' into [{}.{}]", fullFilename, datasetId, tableId);
        CsvOptions csvOptions = CsvOptions.newBuilder()
            .setSkipLeadingRows(1)
            .setFieldDelimiter("\t")
            .build();
        LoadJobConfiguration configuration =
            LoadJobConfiguration.builder(tableRef, fullFilename)
                .setAutodetect(false)
                .setSchema(generateSchema())
                .setWriteDisposition(JobInfo.WriteDisposition.WRITE_APPEND)
                .setCreateDisposition(JobInfo.CreateDisposition.CREATE_IF_NEEDED)
                .setFormatOptions(csvOptions)
                .build();
        Job loadJob = getBigQuery().create(JobInfo.of(configuration));
        LOG.info("Job ID is: " + loadJob.getJobId());
        return loadJob;
    }

    /**
     * Load {@code Job} by job ID
     *
     * @param jobId is the unique job ID
     * @return {@code Job}
     */
    public static Job loadJobById(String jobId) {
        return getBigQuery().getJob(jobId);
    }

    /**
     * Check whether the job successes or not
     * @param job is {@code Job}
     * @return {@code true} if job runs successfully
     */
    public static boolean isJobRunSuccess(Job job) {
        return job.exists() && job.isDone() && job.getStatus().getError() == null;
    }

}
