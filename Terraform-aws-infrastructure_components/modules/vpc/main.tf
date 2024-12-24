# modules/vpc/main.tf
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  
  name = "${var.environment}-vpc"
  cidr = var.vpc_cidr
  
  azs             = var.availability_zones
  private_subnets = [for i in range(length(var.availability_zones)) : 
    cidrsubnet(var.vpc_cidr, 8, i)]
  public_subnets  = [for i in range(length(var.availability_zones)) : 
    cidrsubnet(var.vpc_cidr, 8, i + length(var.availability_zones))]
  
  enable_nat_gateway = true
  single_nat_gateway = true
  map_public_ip_on_launch = true
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Environment = var.environment
    Terraform   = "true"
  }

  
}
