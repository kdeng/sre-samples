# Report BigQuery Job Checker - DOING

This repository is a micro-service for checking BigQuery job status by using AppEngine Task Push Queue.

#### Key Function

This service is a push-queue handler to consume a request for checking the BigQuery job state.

The request body contains an unique job ID, and this service checks the job state, and report the errors if job fails.

###