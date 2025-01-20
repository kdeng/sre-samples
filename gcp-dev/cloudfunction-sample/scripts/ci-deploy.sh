#!/usr/bin/env bash

PROJECT_ID="kdeng-gcp-demo"
TRIGGER_RESOURCE="kdeng-subpub-trigger"
TRIGGER_EVENT="google.pubsub.topic.publish"

echo "Deploy CloudFunction to ($PROJECT_ID)"

gcloud beta functions deploy \
    kdeng-cloudfunction-demo \
    --entry-point=subscribe \
    --project=${PROJECT_ID} \
    --trigger-resource=${TRIGGER_RESOURCE} \
    --trigger-event=${TRIGGER_EVENT} \
    --memory=128MB \
    --timeout=540
