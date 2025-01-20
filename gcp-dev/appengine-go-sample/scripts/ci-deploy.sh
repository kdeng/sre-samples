#!/usr/bin/env bash

# Force the shell to immediately if a single command exits with a non-zero exit value.
set -e

# Turn on / off the debug mode
# set -x
GCP_PROJECT_ID=$PROJECT

GAE_SERVICE_NAME=$SERVICE_NAME

# Define the version number
VERSION=$(date '+%Y%m%d-%H%M%S')

GO_VERSION=1.10.2

WORD_DIR=`pwd`
echo -e "\n[PREPARE]: Current work directory is $WORD_DIR"

install_golang() {
    echo -e "\n[INSTALL]: Install go tools"
    apt-get -y install wget
    cd /tmp && wget https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz
    tar -C /usr/local -xzf go$GO_VERSION.linux-amd64.tar.gz
    export PATH=$PATH:/usr/local/go/bin
    go version
    echo -e "\n[INSTALL]: Go back to work directory $WORD_DIR"
    cd $WORD_DIR
    export GOPATH=$WORD_DIR/dist
}

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
    files_to_ignore=".DS_Store|test"

    rm -rf ./dist
    mkdir -p ./dist/src/main

    echo -e "\n[Build]: Start to deploy default service to project '$project_id'"

    echo -e "\n[Build]: Generating resources"
    find ./appengine -maxdepth 1 ! -path ./appengine | egrep -v "${library_to_ignore}" | xargs -IELEMENT cp -r ELEMENT ./dist/src/main

    echo -e "\n[Build]: Copying all modules"
    find ./src -maxdepth 1  -type f ! -path ./src | egrep -v "${files_to_ignore}" | xargs -IELEMENT cp -r ELEMENT ./dist/src/main

    echo -e "\n[Build]: Copying all libraries"
    find ./src -maxdepth 1  -type d ! -path ./src | egrep -v "${files_to_ignore}" | xargs -IELEMENT cp -r ELEMENT ./dist/src

    echo -e "\n[INSTALL]: Install go packages to GOPATH=$GOPATH"
    go get -u -v github.com/julienschmidt/httprouter
    go get -u -v google.golang.org/appengine
    go get -u -v cloud.google.com/go/bigquery

    echo -e "[Build]: Starting to deploy GAE service"
    cd ./dist && gcloud app deploy ./src/main/app.yaml ./src/main/cron.yaml ./src/main/queue.yaml --quiet --project="$project_id" --promote --version="$version"
    echo -e "\n[Deploy]: Deploy version [$version] successfully"

    # Delete all previous version
    previous_versions=$(gcloud app versions list --project "$project_id" --service "$service_name" | egrep -v "$version|VERSION" | awk '{print $2}')
    joined_previous_versions=$(echo "$previous_versions" | paste -sd "," -)
    if [ ! -z "$previous_versions" ]; then
        echo -e "\n[Deploy]: Deleting previous version '$joined_previous_versions'"
        gcloud app versions delete --quiet --project "$project_id" $previous_versions
    fi

    echo -e "\n\n======= DONE ======="

}


install_golang
login_gcp_with_service_account ./$GCP_PROJECT_ID.service-account-key.json
build_and_deploy_appengine_service $GCP_PROJECT_ID $VERSION $GAE_SERVICE_NAME
