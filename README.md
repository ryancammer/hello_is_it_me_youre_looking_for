# Hello! Is it me you're looking for?

## Problem

Here’s a take-home from an upcoming interview:
Assignment: Build a Docker Container for a GoLang Hello World Application using Terraform or CloudFormation.
To validate your technical keenness and skillset, ____ is requesting you build a Docker container for a simple GoLang Hello World application. You will use Terraform or CloudFormation to automate the building, deploying, and managing of the infrastructure for your Docker container.

Objectives:
* Create a simple GoLang Hello World application
* Build a Docker image of the application
* Use Terraform or CloudFormation to automate the deployment of the Docker container
* Ensure to use best practices regarding security (credential handling)
* Please use Gitlab or Github and be ready to share and speak about your code
* How would you deploy this application using ECS/Kubernetes?

## Solution

This Hello World web application is written in Go and uns on
[AWS ECS Fargate](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/AWS_Fargate.html). 
It uses [GitHub Actions](https://docs.github.com/en/actions) 
to build the code and container image, which is hosted on
[GitHub Packages](https://github.com/features/packages). Terraform is used to
deploy the application to AWS.

## Building

To build the app, run the following command: `cd src/ && go build -v ./...`.

__Note:__ The `go.mod` file is located in the `src/` directory.

## Deploying

Change directories into the `terraform/` directory and run the following commands:

```bash
terraform init
terraform apply
```

__NOTE__: Terraform State is stored locally in the `terraform/` directory.

## TODO

- [ ] Display the public ip address that enables access to the application.
- [ ] Add a GitHub Action to deploy the application to AWS.

