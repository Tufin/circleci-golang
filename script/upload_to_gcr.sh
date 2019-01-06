#!/bin/bash

set -euf -o pipefail

function upload_to_gcr() {
    local source_image=$1
    local target_image=$2
    local build_number=$3
    local branch=$4

    echo "source_image $source_image, target_image=$target_image, build_number=$build_number, branch=$branch"

    # tag image
    docker tag "${source_image}" "${target_image}"
    docker tag "${source_image}" "${target_image}:${build_number}-${branch}"
    docker tag "${source_image}" "${target_image}:${branch}"
    docker tag "${source_image}" "${target_image}:${build_number}"

    # run gcloud
    gcloud auth configure-docker --quiet
    docker push "${target_image}"
    # gcloud docker -- push "${target_image}"
}

# $1 - local image name (SOURCE_IMAGE for the docker tag command)
# $2 - remote image name (TARGET_IMAGE for the docker tag command)
# $3 - build number
# $4 - branch
upload_to_gcr $1 $2 $3 $4
