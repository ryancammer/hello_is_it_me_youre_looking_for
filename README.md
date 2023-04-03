# Hello! Is it me you're looking for?

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

