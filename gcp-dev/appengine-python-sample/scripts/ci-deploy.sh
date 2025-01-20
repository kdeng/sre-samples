#!/usr/bin/env bash

# Force the shell to immediately if a single command exits with a non-zero exit value.
set -e

# Turn on / off the debug mode
#set -x
GCP_PROJECT_ID=$PROJECT
GAE_SERVICE_NAME=$SERVICE_NAME

echo -e "\n\nDeploy latest service [$GAE_SERVICE_NAME] to project [$GCP_PROJECT_ID]\n"

# Define the version number
VERSION=$(date '+%Y%m%d-%H%M%S')

login_gcp_with_service_account() {
    echo -e "\n[LOGIN]: Login with service account"
    gcloud auth activate-service-account --key-file $1
    gcloud auth list
}

build_and_deploy_appengine_service() {

    project_id=$1
    version=$2
    service_name=$3
    library_to_ignore=".DS_Store"
    files_to_ignore=".DS_Store|__init__|test"

    rm -rf ./dist
    mkdir -p ./dist

    echo -e "\n[Build]: Start to deploy default service to project '$project_id'"

    echo -e "\n[Build]: Generating resources"
    find ./appengine -maxdepth 1 ! -path ./appengine | egrep -v "${library_to_ignore}" | xargs -IELEMENT cp -r ELEMENT ./dist

    echo -e "\n[Build]: Copying all modules"
    find ./src -maxdepth 1 ! -path ./src | egrep -v "${files_to_ignore}" | xargs -IELEMENT cp -r ELEMENT ./dist

    echo -e "[Build]: Install all libraries"
    cd ./dist && pip install -t lib -r requirements.txt
    gcloud app deploy ./app.yaml ./queue.yaml --quiet --project="$project_id" --promote --version="$version"
    echo -e "\n[Deploy]: Deploy version [$version] successfully"

    # Delete all previous version
    previous_versions=$(gcloud app versions list --project="$project_id" --service="$service_name" | egrep -v "$version|VERSION" | awk '{print $2}')
    joined_previous_versions=$(echo "$previous_versions" | paste -sd "," -)
    if [ ! -z "$previous_versions" ]; then
        echo -e "\n[Deploy]: Deleting previous version '$joined_previous_versions'"
        gcloud app versions delete --quiet --project="$project_id" --service="$service_name" $previous_versions
    fi

    echo -e "\n\n======= DONE ======="

}

login_gcp_with_service_account ./$GCP_PROJECT_ID.service-account-key.json
build_and_deploy_appengine_service $GCP_PROJECT_ID $VERSION $GAE_SERVICE_NAME
