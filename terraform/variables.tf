variable "aws_access_key" {
  type        = string
  description = "AWS Access Key"
}

variable "aws_secret_key" {
  type        = string
  description = "AWS Secret Key"
}

variable "aws_region" {
  type        = string
  description = "AWS Region"
}

variable "aws_cloudwatch_retention_in_days" {
  type        = number
  description = "AWS CloudWatch Logs Retention in Days"
  default     = 1
}

variable "app_name" {
  type        = string
  description = "Application Name"
}

variable "app_environment" {
  type        = string
  description = "Application Environment"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones"
}

variable "service_container_image_url" {
  type        = string
  description = "The url of the docker image"
  default     = "ghcr.io/ryancammer/hello_is_it_me_youre_looking_for:main"
}

variable "ghcr_token" {
  type        = string
  description = "The token to access the ghcr.io registry"
  sensitive   = true
}

variable "ghcr_username" {
  type        = string
  description = "The username to access the ghcr.io registry"
  sensitive   = true
}

