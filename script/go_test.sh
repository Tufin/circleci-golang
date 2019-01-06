#!/bin/bash

set -euf -o pipefail

go_test() {

    local test_results=$1
    local build_dir=$2

    cd $build_dir

    echo "Running go fix..."
    go fix $(go list ./... | grep -v /vendor/)
    
    echo "Running vet..."
    go vet $(go list ./... | grep -v /vendor/)
    
    echo "Running lint..."
    issues=$(golint $(go list ./... | grep -v /vendor/) | { grep -v " should have comment " || true; })
    if [ "$issues" != "" ]
    then
        echo "$issues"
    fi

    echo "Running tests..."
    mkdir -p "${test_results}"
    trap "go-junit-report <${test_results}/go-test.out > ${test_results}/go-test-report.xml" EXIT
    go test -race -v $(go list ./... | grep -v /vendor/) | tee "${test_results}/go-test.out"
}

# $1 - test results path
# $2 - subdir in monorepo
go_test $1 $2
