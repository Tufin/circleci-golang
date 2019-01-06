# circleci-golang
Docker image for building golang in CircleCI and updating pods in GKE

Provides scripts for:

1. Authentication with gcloud
2. Run unit tests and compile (Go)
3. Upload to Google Container Registry
4. Deployment of a docker image to a kubernetes cluster

Recommended to use this for local builds to ensure uniform versions of tools like `dep` etc.
