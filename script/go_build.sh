#!/bin/bash

set -euf -o pipefail

go_build() {
    local binary_name=$1
    local build_dir=$2
    local dist_dir=".dist"

    dep ensure -v
    cd $build_dir

    sudo rm -rf "${dist_dir}"
    mkdir "${dist_dir}"
    CGO_ENABLED=0 go build -v -o "${dist_dir}/${binary_name}"
}

# $1 - binary name
# $2 - subdir in monorepo
go_build $1 $2
