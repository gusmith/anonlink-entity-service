#!/usr/bin/env bash
set -e
script_name=$(basename "$0")
cd $(dirname "$0")

export BRANCH_NAME=$(git rev-parse --abbrev-ref HEAD)

if [ "$BRANCH_NAME" = "master" ];
then
    echo "Pushing images to quay.io";
    export APPVERSION=$(cat ../backend/VERSION);
    docker push quay.io/n1analytics/entity-app:${APPVERSION};
    docker push quay.io/n1analytics/entity-nginx:v1.2.6;
else
    echo "Uploading with label: ${BRANCH_NAME}";
    docker push quay.io/n1analytics/entity-app:${BRANCH_NAME};
    docker push quay.io/n1analytics/entity-nginx:${BRANCH_NAME};
fi
