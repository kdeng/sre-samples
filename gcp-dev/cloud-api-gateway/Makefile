.ONESHELL:
.SHELL := /bin/bash

PROJECT_ID = kefeng-playground
GCP_REGION = australia-southeast1
API_ID = api-demo
API_CONFIG_ID = api-demo-config
GATEWAY_ID = api-demo-gateway
API_BACKEND_SERVICE_ACCOUNT = api-gateway-robot@kefeng-playground.iam.gserviceaccount.com
OPEN_API_SPEC = ./openapi2.yaml

init:
	@gcloud services enable apigateway.googleapis.com
	@gcloud services enable servicemanagement.googleapis.com
	@gcloud services enable servicecontrol.googleapis.com

deploy-api:
	@gcloud api-gateway apis create $(API_ID) --project=$(PROJECT_ID)

deploy-api-config:
	@gcloud api-gateway api-configs create $(API_CONFIG_ID) \
		--api=$(API_ID) \
		--openapi-spec=$(OPEN_API_SPEC) \
		--project=$(PROJECT_ID) \
		--backend-auth-service-account=$(API_BACKEND_SERVICE_ACCOUNT)

deploy-api-gateway:
	gcloud api-gateway gateways create $(GATEWAY_ID) \
		--api=$(API_ID) \
		--api-config=$(API_CONFIG_ID) \
		--location=$(GCP_REGION) \
		--project=$(PROJECT_ID)

	$(eval SERVICE_NAME=$(shell gcloud api-gateway apis describe $(API_ID) | grep managedService | sed -r 's/managedService: //g'))
	gcloud services enable $(SERVICE_NAME)

destroy:
	$(eval SERVICE_NAME=$(shell gcloud api-gateway apis describe $(API_ID) | grep managedService | sed -r 's/managedService: //g'))
	gcloud services disable $(SERVICE_NAME)

	-gcloud api-gateway gateways delete $(GATEWAY_ID) \
		--project $(PROJECT_ID) \
		--location $(GCP_REGION)
	-gcloud api-gateway api-configs delete $(API_CONFIG_ID) \
		--api $(API_ID) \
		--project $(PROJECT_ID)
	-gcloud api-gateway apis delete $(API_ID) \
		--project $(PROJECT_ID)
