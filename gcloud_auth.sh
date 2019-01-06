#!/bin/bash

set -euf -o pipefail

gcloud_service_key_file="/tmp/gcloud-service-key.json"

rm -rf "${gcloud_service_key_file}"

# read service key from stdin and write it to a tmp file
sudo base64 --decode --ignore-garbage /dev/stdin > "${gcloud_service_key_file}"

# authenticate to gcloud
gcloud auth activate-service-account --key-file "${gcloud_service_key_file}"

rm -rf "${gcloud_service_key_file}"


