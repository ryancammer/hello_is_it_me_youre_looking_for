variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "cluster_id" {
  description = "The ECS cluster ID"
  type        = string
}

variable "ghcr_secret_id" {
  description = "The secret ID for the AWS secrets manager secret for accessing the GitHub Container Registry"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
}

variable "service_container_image_url" {
  type        = string
  description = "The url of the docker image"
}

variable "container_image_access_token" {
  type        = string
  description = "The access token to access the docker image"
  sensitive   = true
}

variable "security_groups" {
  type        = list(string)
  description = "The security groups to attach to the ECS service"
}

variable "public_subnets" {
  type        = list(string)
  description = "The public subnets to attach to the ECS service"
}
