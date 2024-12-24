# backend/main.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
  backend "s3" {
    bucket = "my-terraform-state-bucket-cloud"
    key    = "terraform.tfstate"
    region = "us-east-1"
    encrypt = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "security" {
  source = "./modules/security"
  
  vpc_id      = module.vpc.vpc_id
  environment = var.environment
}

module "ec2" {
  source = "./modules/ec2"
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.public_subnet_ids[0]
  security_group_id = module.security.app_security_group_id
  instance_type     = var.instance_type
  environment       = var.environment
  ssh_key_name     = "ivolve-final-project"  # Name of your existing key pair in AWS
}

module "monitoring_jenkins_dev" {
  source = "./modules/monitoring"
  
  environment = "${var.environment}-jenkins-dev"
  instance_id = module.ec2.jenkins_dev_instance_id
}

module "monitoring_jenkins_prod" {
  source = "./modules/monitoring"
  
  environment = "${var.environment}-jenkins-prod"
  instance_id = module.ec2.jenkins_prod_instance_id
}

module "monitoring_sonarqube_dev" {
  source = "./modules/monitoring"
  
  environment = "${var.environment}-sonarqube-dev"
  instance_id = module.ec2.sonarqube_dev_instance_id
}

module "monitoring_sonarqube_prod" {
  source = "./modules/monitoring"
  
  environment = "${var.environment}-sonarqube-prod"
  instance_id = module.ec2.sonarqube_prod_instance_id
}
