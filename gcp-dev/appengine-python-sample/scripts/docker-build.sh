#!/usr/bin/env bash

project_id="kdeng-gcp-demo"
environment="dev"
service_name="kdeng-gae-bigquery-service"

docker run --rm -it \
    --user root \
    -v $(PWD):/app \
    -e PROJECT="$project_id-$environment" \
    -e SERVICE_NAME="$service_name" \
    -w /app google/cloud-sdk:latest \
    sh -c "/app/scripts/ci-deploy.sh"
