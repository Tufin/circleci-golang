FROM circleci/golang

# Google SDK
RUN sudo apt-get update -y && sudo apt-get install -y lsb-release bsdmainutils
RUN CLOUD_SDK_REPO="cloud-sdk-$(lsb_release -c -s)" && echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
RUN sudo apt-get update && sudo apt-get install -y google-cloud-sdk

# kubectl
RUN sudo apt-get install -y kubectl

# package manager
RUN sudo curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
RUN sudo chmod +x $GOPATH/bin/dep

# golint prints out style mistakes
RUN go get -u github.com/golang/lint/golint

# converting go test results into junit.xml format
RUN go get -v github.com/jstemmer/go-junit-report

# cleanup
RUN sudo apt-get clean && sudo apt-get autoclean && sudo apt-get autoremove
RUN rm -rf openshift-origin-client-tools-v*

# add scripts
COPY script/* /scripts/
RUN sudo chmod +x /scripts/*

# set permissions on /work so that we can use it as a volume (without sudo)
RUN sudo mkdir /work && sudo chown -R circleci:circleci /work

WORKDIR /scripts
