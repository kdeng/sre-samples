.ONESHELL:
.SHELL := /bin/bash

PROJECT_ID = kefeng-playground

deploy:
	@gcloud beta app deploy --appyaml=app.yaml \
		--version=test \
		--quiet --promote \
		--project=$(PROJECT_ID) \
		--verbose

destroy:
	-gcloud beta compute security-policies delete $(CLOUD_RUN_SERVICE_NAME)-policy --project $(PROJECT_ID) --quiet

