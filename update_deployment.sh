#!/bin/bash

# run without -e to avoid breaking the build if no clusters are deployed
set -uf -o pipefail

function update_deployment() {

    ns="$6"
    if [ -z "$ns" ]; then
        ns=default
    fi

    echo "Project ID: $1, Cluster: $2, Zone: $3, Deployment: $4, Container to update: $5, Namespace: $ns"

    ok=`gcloud container clusters list --project "$1"`
    if [ -z "$ok" ]
    then
        echo "Can't update docker image on Google Cloud, no Kubernetes cluster found at $1"
    else
        gcloud container clusters get-credentials "$2" --zone="$3" --project="$1"
        if [ $? -ne 0 ]; then
                echo "Failed to fetch credentials for cluster $2"
                exit 0 # exit without breaking the build
        fi

        kubectl set image "$4" "$5" -n "$ns"
        if [ $? -ne 0 ]; then
                echo "Failed to update deployment $4"
                exit 0 # exit without breaking the build
        fi

        echo "Deployment updated successfully"
    fi
}

# $1 - gcloud project id
# $2 - gcloud Kubernetes cluster name
# $3 - gcloud zone
# $4 - Kubernetes deployment name
# $5 - updated docker image
# $6 - namespace

cluster=$2
commit_message="$(git log --format=oneline -n 1 $CIRCLE_SHA1)"
branch_deploy_cluster=`echo ${commit_message} | sed -n 's/.*\(\[deploy \([0-9a-zA-Z_-]*\)\]\)$/\2/p'`
if [[ "$CIRCLE_BRANCH" != "master" ]]; then
    if [[ -n ${branch_deploy_cluster} ]]; then
      cluster=${branch_deploy_cluster}
    else
        echo "No deployment by default when committing to a branch. Use '[deploy <cluster-name>]' at the end of the commit message for deployment."
        exit 0
    fi
fi

update_deployment $1 $cluster $3 $4 $5 $6
