terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.6"
    }
  }

  required_version = ">= 1.4"
}

locals {
  credentials = {
    username = var.ghcr_username
    password = var.ghcr_token
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.app_name}-${var.app_environment}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-west-2a"]
  public_subnets  = ["10.0.101.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    Terraform = "true"
    Environment = var.app_environment
  }
}

module "ecs" {
  source = "terraform-aws-modules/ecs/aws"

  cluster_name = "${var.app_name}-${var.app_environment}-ecs-fg"

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }

    network_configuration = {
      subnets = module.vpc.public_subnets
      security_groups = [module.vpc.default_security_group_id]
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  tags = {
    Environment = var.app_environment
    Project     = var.app_name
  }
}

resource "aws_secretsmanager_secret" "ghcr_secret" {
  name = "ghcr_secret_${var.app_environment}"
}

resource "aws_secretsmanager_secret_version" "ghcr_secret_version" {
  secret_id     = aws_secretsmanager_secret.ghcr_secret.id
  secret_string = jsonencode(local.credentials)
}

module "hello_world_service" {
  source = "./modules/service"

  app_environment = var.app_environment
  cluster_id = module.ecs.cluster_id
  ghcr_secret_id = aws_secretsmanager_secret.ghcr_secret.id
  region = var.aws_region
  service_container_image_url = var.service_container_image_url
  container_image_access_token = var.ghcr_token
  public_subnets = module.vpc.public_subnets
  security_groups = [module.vpc.default_security_group_id]
}
