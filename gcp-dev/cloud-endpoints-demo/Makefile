.ONESHELL:
.SHELL := /bin/bash

PROJECT_ID = kefeng-playground
GCP_REGION = australia-southeast1

CLOUD_RUN_HOSTNAME=api-demo-v4-x2avudvmgq-uc.a.run.app
CONFIG_ID=2022-03-25r0

ESP_V2_CLOUD_RUN_SERVICE_NAME=endpoint-esp-v2

init:
	@gcloud services enable servicemanagement.googleapis.com
	@gcloud services enable servicecontrol.googleapis.com
	@gcloud services enable endpoints.googleapis.com

deploy-endpoints:
	@gcloud endpoints services deploy openapi.yaml --project=$(PROJECT_ID)

build-image:
	./gcloud_build_image -s $(CLOUD_RUN_HOSTNAME) \
    -c $(CONFIG_ID) \
    -p $(PROJECT_ID)

deploy-espv2-image:
	gcloud run deploy $(ESP_V2_CLOUD_RUN_SERVICE_NAME) \
    --image="gcr.io/$(PROJECT_ID)/endpoints-runtime-serverless:2.35.0-api-demo-v4-x2avudvmgq-uc.a.run.app-2022-03-25r0" \
    --allow-unauthenticated \
    --platform managed \
    --project=$(PROJECT_ID) \
    --region=$(GCP_REGION)

add-iam-policy:
	gcloud projects add-iam-policy-binding $(PROJECT_ID) \
    --member "serviceAccount:145940974360-compute@developer.gserviceaccount.com" \
    --role roles/servicemanagement.serviceController

destroy:
	-gcloud endpoints services delete $(CLOUD_RUN_HOSTNAME)
