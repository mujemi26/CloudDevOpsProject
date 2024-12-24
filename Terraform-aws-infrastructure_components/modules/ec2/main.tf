



# Jenkins Dev Instance
resource "aws_instance" "jenkins_dev" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [var.security_group_id]
  key_name = var.ssh_key_name
  
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  
  tags = {
    Name        = "${var.environment}-jenkins-dev"
    Environment = var.environment
    Terraform   = "true"
  }

  provisioner "local-exec" {
    command = "echo 'Jenkins Dev Public IP: ${self.public_ip}' >> instance_ips.txt"
  }
}

# Jenkins Prod Instance
resource "aws_instance" "jenkins_prod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [var.security_group_id]
  key_name = var.ssh_key_name
  
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  
  tags = {
    Name        = "${var.environment}-jenkins-prod"
    Environment = var.environment
    Terraform   = "true"
  }

  provisioner "local-exec" {
    command = "echo 'Jenkins Prod Public IP: ${self.public_ip}' >> instance_ips.txt"
  }
}

# SonarQube Dev Instance
resource "aws_instance" "sonarqube_dev" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [var.security_group_id]
  key_name = var.ssh_key_name
  
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  
  tags = {
    Name        = "${var.environment}-sonarqube-dev"
    Environment = var.environment
    Terraform   = "true"
  }

  provisioner "local-exec" {
    command = "echo 'SonarQube Dev Public IP: ${self.public_ip}' >> instance_ips.txt"
  }
}

# SonarQube Prod Instance
resource "aws_instance" "sonarqube_prod" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  associate_public_ip_address = true
  vpc_security_group_ids = [var.security_group_id]
  key_name = var.ssh_key_name
  
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }
  
  tags = {
    Name        = "${var.environment}-sonarqube-prod"
    Environment = var.environment
    Terraform   = "true"
  }

  provisioner "local-exec" {
    command = "echo 'SonarQube Prod Public IP: ${self.public_ip}' >> instance_ips.txt"
  }
}

# Ubuntu AMI data source
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]  # Canonical's official AWS account ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }



  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

