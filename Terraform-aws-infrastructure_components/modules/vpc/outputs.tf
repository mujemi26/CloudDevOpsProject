output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnet_cidr_blocks" {
  description = "List of cidr blocks of public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "nat_gateway_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = module.vpc.nat_public_ips
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}
