# AWS Infrastructure with Terraform 🚀

## Project Overview 📋

This project contains Terraform configurations to deploy a complete AWS infrastructure including VPC, EC2 instances, security groups, and monitoring for Jenkins and SonarQube environments in both development and production.

## Infrastructure Components 🏗️

- VPC with custom networking
- Security Groups
- EC2 Instances for Jenkins and SonarQube
- CloudWatch Monitoring
- S3 Backend for Terraform State
- DynamoDB for State Locking

## Prerequisites 📝

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- AWS account with required permissions
- SSH key pair in AWS named "ivolve-final-project"

## Required Providers 🔧

- AWS Provider (~> 5.0)
- TLS Provider (~> 4.0)
- Local Provider (~> 2.0)

## Project Structure 📂

```bash
.
├── main.tf
├── variables.tf
├── outputs.tf
└── modules/
├── vpc/
├── security/
├── ec2/
└── monitoring/
```

## Remote State Configuration 💾

The project uses S3 backend for storing Terraform state with the following configuration:

- Bucket: my-terraform-state-bucket-cloud
- Region: us-east-1
- State file key: terraform.tfstate
- State locking: Enabled (using DynamoDB)
- Encryption: Enabled

## Modules Description 📚

### VPC Module

- Creates custom VPC with specified CIDR
- Sets up public subnets across availability zones
- Configures internet gateway and routing

### Security Module

- Manages security groups
- Configures inbound/outbound rules
- Implements network access controls

### EC2 Module

- Provisions EC2 instances for:
  - Jenkins (Dev & Prod)
  - SonarQube (Dev & Prod)
- Configures instance types and SSH access

### Monitoring Module

- Sets up CloudWatch monitoring
- Configures alarms and metrics
- Separate monitoring for each environment

## Usage 🛠️

1. Clone the repository:

```bash
git clone <repository-url>
```

# Terraform Variables Configuration 🔧

## Overview 📝

This Part outlines the input variables used in our Terraform AWS infrastructure configuration. These variables allow for flexible and reusable infrastructure deployment across different environments.

## Variables Reference 📚

### Region Configuration 🌎

```hcl
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}
```

Defines the AWS region where resources will be deployed. Default is set to US East (N. Virginia).

### Environment Settings 🏢

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}
```

Specifies the environment name (e.g., production, staging, development).

### Network Settings 🌐

#### VPC CIDR Range

```hcl
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}
```

Defines the IP address range for the Virtual Private Cloud (VPC).

#### Availability Zones

```hcl
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
```

Specifies the AWS availability zones for high availability deployment.

### Compute Settings 💻

#### Instance Type

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.large"
}
```

Defines the EC2 instance type for compute resources.

### SSH Access 🔑

```hcl
variable "ssh_key_name" {
  description = "Name of existing SSH key pair in AWS"
  type        = string
}
```

Specifies the name of the SSH key pair for instance access (required).

## Usage Guide 🚀

```text
1. Basic Usage
   Create a terraform.tfvars file in your project directory:
```

```hcl
aws_region = "us-east-1"
environment = "production"
vpc_cidr = "10.0.0.0/16"
ssh_key_name = "your-key-name"
```

## Important Notes ⚠️

### Prerequisites:

    AWS account and credentials configured

    Terraform installed (version >= 0.12)

    Existing SSH key pair in AWS

# VPC Module Configuration 🌐

## Overview 🔍

This module configures an AWS Virtual Private Cloud (VPC) using the official AWS VPC Terraform module. It sets up a complete networking environment with public and private subnets, NAT Gateway, and DNS support.

## Architecture Diagram 🏗️

                                Internet Gateway
                                       ⬆
                                       |
                +--------------------VPC--------------------+
                |                                          |
        Public Subnet(s)                        Private Subnet(s)
                |                                     ⬆
                |                                     |
                +----------------NAT Gateway----------->

## Features ⭐

- Multi-AZ VPC architecture
- Automatic CIDR block calculation
- Public and private subnets
- NAT Gateway for private subnet internet access
- DNS support enabled
- Automatic tagging system

## Module Configuration 🛠️

### Basic Usage

```hcl
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
```

### Network Components 🔧

#### Subnets Configuration:

    Public Subnets : Automatically calculated CIDR blocks

    Private Subnets : Automatically calculated CIDR blocks

    Subnet Distribution : One of each type per AZ

#### Networking Features

- ✅ NAT Gateway (Single NAT configuration)

- ✅ Auto-assign public IPs

- ✅ DNS hostnames

- ✅ DNS support

### Resource Tagging 🏷️

```hcl
tags = {
  Environment = var.environment
  Terraform   = "true"
}
```

# VPC Module Variables Configuration 🔧

## Overview 📝

This Part details the input variables required for the VPC (Virtual Private Cloud) module configuration in AWS using Terraform. These variables are essential for defining the network architecture and environment settings.

## Required Variables 🚀

### 1. VPC CIDR Block Configuration 🌐

```hcl
variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}
```

Purpose

- Defines the IP address range for your entire VPC

- Determines the number of available IP addresses

### 2. Availability Zones Configuration 🏢

```hcl
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}
```

Purpose

- Specifies AWS availability zones for resource distribution

- Enables high availability architecture

Best Practices

- Use minimum of 2 AZs for high availability

- Verify AZ availability in your chosen region

- Consider regional service limitations

### 3. Environment Configuration 🌍

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
}
```

Purpose

- Identifies the deployment environment

- Used for resource tagging and naming

# VPC Module Outputs Documentation 📤

## Overview 🔍

This Part details the output values exposed by the VPC module. These outputs provide essential information about the created VPC resources and can be used by other modules or as reference information.

## Available Outputs 📋

### 1. VPC Identifier 🏢

```hcl
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}
```

- Returns the unique identifier of the created VPC

- Format: vpc-xxxxxxxx

- Usage: Reference for security groups, subnets, etc.

### 2. Private Subnet Information 🔒

```hcl
output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}
```

- Returns list of private subnet IDs

- Format: ["subnet-xxxxxxxx", "subnet-yyyyyyyy"]

- Usage: For private resources deployment

### 3. Public Subnet Information 🌐

```hcl
output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}
```

- Returns list of public subnet IDs

- Format: ["subnet-a", "subnet-b"]

- Usage: For internet-facing resources

### 4. Public Subnet CIDR Blocks 📍

```hcl
output "public_subnet_cidr_blocks" {
  description = "List of cidr blocks of public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}
```

- Returns CIDR ranges for public subnets

- Format: ["10.0.1.0/24", "10.0.2.0/24"]

- Usage: Network planning and documentation

### 5. NAT Gateway Information 🔄

```hcl
output "nat_gateway_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = module.vpc.nat_public_ips
}
```

- Returns public IP(s) of NAT Gateway(s)

- Format: ["54.x.x.x"]

- Usage: Outbound internet access configuration

### 6. VPC CIDR Block 🌍

```hcl
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}
```

- Returns main VPC CIDR range

- Format: 10.0.0.0/16

- Usage: Network planning and documentation

### Output Display

```bash
# View all outputs
terraform output

# View specific output
terraform output vpc_id
```

# AWS Security Group Configuration 🛡️

## Overview 🔍

This Part details the configuration of an AWS Security Group designed for application servers. The security group includes rules for HTTP, HTTPS, SSH, Jenkins, and SonarQube access, along with outbound traffic permissions.

## Security Group Configuration 🔒

### Basic Information

```hcl
name        = "${var.environment}-app-sg"
description = "Security group for application servers"
vpc_id      = var.vpc_id
```

## Inbound Rules (Ingress) ⬇️

### 1. HTTP Access 🌐

```hcl
ingress {
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

- Allows standard HTTP traffic

- Port: 80

- Source: All IPv4 addresses

### 2. HTTPS Access 🔐

```hcl
ingress {
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
```

- Allows secure HTTPS traffic

- Port: 443

- Source: All IPv4 addresses

### 3. SSH Access 💻

```hcl
ingress {
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "SSH access"
}
```

- Allows SSH connections

- Port: 22

- Source: All IPv4 addresses

### 4. Jenkins Access 🔧

```hcl
ingress {
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Jenkins web access"
}
```

- Allows Jenkins web interface access

- Port: 8080

- Source: All IPv4 addresses

### 5. SonarQube Access 📊

```hcl
ingress {
  from_port   = 9000
  to_port     = 9000
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  description = "SonarQube web access"
}
```

- Allows SonarQube web interface access

- Port: 9000

- Source: All IPv4 addresses

## Outbound Rules (Egress) ⬆️

```hcl
egress {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}
```

- Allows all outbound traffic

- All ports and protocols

- Destination: All IPv4 addresses

## Resource Tagging 🏷️

```hcl
tags = {
  Environment = var.environment
  Terraform   = "true"
}
```

# Security Group Variables Configuration 🔧

## Overview 📝

This Part outlines the input variables required for configuring AWS Security Groups. These variables are essential for defining the network context and environment settings for your security group resources.

## Required Variables ⚙️

### 1. VPC ID Configuration 🌐

```hcl
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
```

Purpose

- Specifies the VPC where security groups will be created

- Links security group to specific network environment

- Required for resource isolation

### 2. Environment Configuration 🏢

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
}
```

Purpose

- Defines the deployment environment

- Used for resource naming and tagging

- Helps in resource organization

# Security Group Outputs Documentation 📤

## Overview 🔍

This Part details the output values exposed by the Security Group module. These outputs provide essential information about the created security group, including its identifier, name, and associated rules.

## Available Outputs 📋

### 1. Security Group ID 🆔

```hcl
output "app_security_group_id" {
  description = "The ID of the application security group"
  value       = aws_security_group.app_sg.id
}
```

Details

- Returns the unique identifier of the security group

- Format: sg-xxxxxxxxxxxxxxxxx

- Usage: Reference for EC2 instances, RDS, etc.

### 2. Security Group Name 📝

```hcl
output "app_security_group_name" {
  description = "The name of the application security group"
  value       = aws_security_group.app_sg.name
}
```

Details

- Returns the name of the security group

- Format: String (e.g., "production-app-sg")

- Usage: Identification and documentation

### 3. Security Group Rules 📜

```hcl
output "app_security_group_rules" {
  description = "List of security group rules"
  value = {
    ingress = aws_security_group.app_sg.ingress
    egress  = aws_security_group.app_sg.egress
  }
}
```

Details

- Returns complete list of ingress and egress rules

- Format: Map of rule configurations

- Usage: Rule verification and documentation

### Output Display

```bash
# View all outputs
terraform output

# View specific security group ID
terraform output app_security_group_id

# View security group rules
terraform output app_security_group_rules
```

# AWS EC2 Instances Module for CI/CD Infrastructure 🚀

## Overview 📋

This Terraform module provisions four EC2 instances for Jenkins and SonarQube in both development and production environments. The infrastructure is designed to support a robust CI/CD pipeline setup.

## Infrastructure Components 🏗️

### Instances Created:

- 🔧 Jenkins Development Server
- 🏭 Jenkins Production Server
- 🔍 SonarQube Development Server
- ✅ SonarQube Production Server

### Common Configuration for All Instances ⚙️

- Base Image: Ubuntu 22.04 LTS (Jammy)
- Volume Type: GP3
- Volume Size: 20GB
- Public IP: Enabled
- Architecture: x86_64

## Prerequisites 📝

- AWS Account
- Terraform installed
- Required AWS permissions
- SSH key pair created in AWS

## Required Variables 🔑

```hcl
variable "instance_type" {
  description = "EC2 instance type"
}

variable "subnet_id" {
  description = "Subnet ID where instances will be created"
}

variable "security_group_id" {
  description = "Security Group ID to be attached to instances"
}

variable "ssh_key_name" {
  description = "Name of the SSH key pair"
}

variable "environment" {
  description = "Environment name (dev/prod)"
}
```

## Features 🌟

- Automated Ubuntu AMI selection (latest version)

- Consistent tagging strategy

- Public IP logging functionality

- GP3 volume type for better performance

- Environment-based naming convention

## Usage 💻

```hcl
module "ec2_instances" {
  source            = "./modules/ec2"
  instance_type     = "t2.medium"
  subnet_id         = "subnet-xxxxxx"
  security_group_id = "sg-xxxxxx"
  ssh_key_name      = "your-key-name"
  environment       = "dev"
}
```

## Outputs 📤

```text
The module creates a local file instance_ips.txt containing the public IPs of all instances.
```

## Tags 🏷️

Each instance is tagged with:

- Name: ${environment}-[service]-[env]

- Environment: Matches the environment variable

- Terraform: "true"

# Terraform Variables Configuration 🔧

## Overview 📋

This Part describes the input variables required for the AWS infrastructure deployment module. These variables are essential for configuring EC2 instances and their associated networking components.

## Required Variables ⚙️

### Network Configuration Variables 🌐

#### VPC ID

```hcl
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}
```

- Required: Yes

- Purpose: Specifies the VPC where resources will be deployed

- Example: vpc-0123456789abcdef0

#### Subnet ID

```hcl
variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}
```

- Required: Yes

- Purpose: Defines the subnet for EC2 instance deployment

- Example: subnet-0123456789abcdef0

#### Security Group ID

```hcl
variable "security_group_id" {
  description = "ID of the security group"
  type        = string
}
```

- Required: Yes

- Purpose: Specifies the security group for network access control

- Example: sg-0123456789abcdef0

### Instance Configuration Variables 💻

#### Instance Type

```hcl
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}
```

- Required: Yes

- Purpose: Defines the AWS EC2 instance size and capabilities

- Example: t2.micro, t2.medium

### Environment Configuration 🌍

- Required: Yes

- Purpose: Specifies the deployment environment

- Example: dev, prod, staging

### Access Configuration 🔑

#### SSH Key Name

```hcl
variable "ssh_key_name" {
  description = "Name of existing SSH key pair in AWS"
  type        = string
}
```

- Required: Yes

- Purpose: Defines the SSH key pair for instance access

- Example: my-aws-key

## Usage Example 📝

```hcl
module "infrastructure" {
  source            = "./modules/infrastructure"

  vpc_id            = "vpc-0123456789abcdef0"
  subnet_id         = "subnet-0123456789abcdef0"
  security_group_id = "sg-0123456789abcdef0"
  instance_type     = "t2.medium"
  environment       = "dev"
  ssh_key_name      = "my-aws-key"
}
```

## Important Notes 📌

- All variables are required and must be of type string

- Ensure all IDs exist in your AWS account before deployment

- Verify SSH key pair exists in the target AWS region

- Match environment names to your organization's naming conventions

# Terraform Output Configuration 📤

## Overview 📋

This document details the output variables for the CI/CD infrastructure deployment. These outputs provide essential information about the Jenkins and SonarQube instances in both development and production environments.

## Output Categories 🗂️

### Instance IDs 🔍

```hcl
jenkins_dev_instance_id
jenkins_prod_instance_id
sonarqube_dev_instance_id
sonarqube_prod_instance_id
```

- Purpose: Provides AWS instance IDs for resource tracking and management

- Usage: Reference these IDs in other AWS operations or monitoring tools

### Network Information 🌐

#### Private IPs

```hcl
jenkins_dev_private_ip
jenkins_prod_private_ip
sonarqube_dev_private_ip
sonarqube_prod_private_ip
```

- Purpose: Internal network addressing

- Usage: Internal service communication and VPC routing

#### Public IPs

```hcl
jenkins_dev_public_ip
jenkins_prod_public_ip
sonarqube_dev_public_ip
sonarqube_prod_public_ip
```

- Purpose: External access endpoints

- Usage: Remote access and service endpoints

### Infrastructure Details ⚙️

#### Availability Zones

```hcl
jenkins_dev_az
jenkins_prod_az
sonarqube_dev_az
sonarqube_prod_az
```

- Purpose: Shows AZ distribution of instances

- Usage: Verify geographical distribution and redundancy

#### Instance States

```hcl
jenkins_dev_state
jenkins_prod_state
sonarqube_dev_state
sonarqube_prod_state
```

- Purpose: Current running state of instances

- Usage: Monitor instance health and availability

#### Resource Tags

```hcl
jenkins_dev_tags
jenkins_prod_tags
sonarqube_dev_tags
sonarqube_prod_tags
```

- Purpose: Resource identification and organization

- Usage: Cost allocation and resource management

## Usage Examples 💡

### Terraform Output

```hcl
terraform output jenkins_dev_public_ip
terraform output sonarqube_prod_instance_id
```

## Troubleshooting 🔧

- Verify instance states before using outputs

- Check network connectivity for IP-based outputs

- Validate tag consistency

- Monitor instance availability

# AWS CloudWatch Monitoring Module 🔍

## Overview 📋

This Terraform module sets up CloudWatch monitoring and alerting for EC2 instances, with automated notifications through SNS when CPU utilization exceeds defined thresholds.

## Components 🏗️

### CloudWatch Alarm ⚠️

```hcl
resource "aws_cloudwatch_metric_alarm" "cpu_alarm"
```

Alarm Configuration Details:

- 🎯 Metric : CPU Utilization

- ⏰ Evaluation Period : 2 periods

- ⌚ Period Length : 300 seconds (5 minutes)

- 📊 Threshold : 80%

- 📈 Statistic : Average

- 🔄 Comparison : Greater Than Threshold

### SNS Topic 📨

```hcl
resource "aws_sns_topic" "alerts"
```

- Creates an SNS topic for alarm notifications

- Topic name includes environment for clear identification

## Prerequisites 📝

- AWS Account with appropriate permissions

- Terraform installed

- EC2 instance(s) running

- IAM permissions for CloudWatch and SNS

# Terraform Variables Configuration for Monitoring Module 📝

## Overview 📋

This Part describes the input variables required for the AWS CloudWatch monitoring module. These variables are essential for setting up monitoring and alerts for EC2 instances.

## Required Variables ⚙️

### Instance Configuration 💻

#### Instance ID

```hcl
variable "instance_id" {
  description = "ID of the EC2 instance"
  type        = string
}
```

- Required: ✅ Yes

- Type: 🔤 String

- Purpose: Identifies the EC2 instance to monitor

- Example: i-1234567890abcdef0

### Environment Configuration 🌍

#### Environment Name

```hcl
variable "environment" {
  description = "Environment name"
  type        = string
}
```

- Required: ✅ Yes

- Type: 🔤 String

- Purpose: Specifies the deployment environment

- Examples: dev, staging, prod

## Important Notes 📌

- Both variables are mandatory

- Instance ID must be valid and accessible

- Environment name affects resource naming

- Variables are used for CloudWatch alarms and SNS topics

# Terraform Monitoring Outputs Documentation 📤

## Overview 📋

This document details the output variables from the AWS CloudWatch monitoring and SNS alerting module. These outputs provide essential information about the created monitoring resources and their configurations.

## Available Outputs 🔍

### CloudWatch Alarm ARN 🚨

```hcl
output "cloudwatch_alarm_arn" {
  description = "ARN of the CloudWatch Alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_alarm.arn
}
```

- Purpose: Provides the Amazon Resource Name (ARN) of the created CloudWatch alarm

- Usage: Reference in other resources or for cross-stack integration

- Format Example: arn:aws:cloudwatch:region:account-id:alarm:alarm-name

### SNS Topic ARN 📢

```hcl
output "sns_topic_arn" {
  description = "ARN of the SNS Topic"
  value       = aws_sns_topic.alerts.arn
}
```

- Purpose: Provides the ARN of the SNS topic used for alarm notifications

- Usage: Subscribe additional endpoints or integrate with other services

- Format Example: arn:aws:sns:region:account-id:topic-name

### Alarm Actions 🎯

```hcl
output "alarm_actions" {
  description = "List of actions to be taken when alarm triggers"
  value       = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_actions
}
```

- Purpose: Lists all configured actions triggered by the alarm

- Usage: Verify alarm notification setup

- Contains: List of ARNs for configured actions

## Command Line Query

```bash
terraform output cloudwatch_alarm_arn
terraform output sns_topic_arn
terraform output alarm_actions
```
