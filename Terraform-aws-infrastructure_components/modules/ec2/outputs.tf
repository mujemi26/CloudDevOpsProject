output "jenkins_dev_instance_id" {
  value = aws_instance.jenkins_dev.id
}

output "jenkins_prod_instance_id" {
  value = aws_instance.jenkins_prod.id
}

output "sonarqube_dev_instance_id" {
  value = aws_instance.sonarqube_dev.id
}

output "sonarqube_prod_instance_id" {
  value = aws_instance.sonarqube_prod.id
}

output "jenkins_dev_private_ip" {
  value = aws_instance.jenkins_dev.private_ip
}

output "jenkins_prod_private_ip" {
  value = aws_instance.jenkins_prod.private_ip
}

output "sonarqube_dev_private_ip" {
  value = aws_instance.sonarqube_dev.private_ip
}

output "sonarqube_prod_private_ip" {
  value = aws_instance.sonarqube_prod.private_ip
}

output "jenkins_dev_public_ip" {
  value = aws_instance.jenkins_dev.public_ip
}

output "jenkins_prod_public_ip" {
  value = aws_instance.jenkins_prod.public_ip
}

output "sonarqube_dev_public_ip" {
  value = aws_instance.sonarqube_dev.public_ip
}

output "sonarqube_prod_public_ip" {
  value = aws_instance.sonarqube_prod.public_ip
}

output "jenkins_dev_az" {
  value = aws_instance.jenkins_dev.availability_zone
}

output "jenkins_prod_az" {
  value = aws_instance.jenkins_prod.availability_zone
}

output "sonarqube_dev_az" {
  value = aws_instance.sonarqube_dev.availability_zone
}

output "sonarqube_prod_az" {
  value = aws_instance.sonarqube_prod.availability_zone
}

output "jenkins_dev_state" {
  value = aws_instance.jenkins_dev.instance_state
}

output "jenkins_prod_state" {
  value = aws_instance.jenkins_prod.instance_state
}

output "sonarqube_dev_state" {
  value = aws_instance.sonarqube_dev.instance_state
}

output "sonarqube_prod_state" {
  value = aws_instance.sonarqube_prod.instance_state
}

output "jenkins_dev_tags" {
  value = aws_instance.jenkins_dev.tags
}

output "jenkins_prod_tags" {
  value = aws_instance.jenkins_prod.tags
}

output "sonarqube_dev_tags" {
  value = aws_instance.sonarqube_dev.tags
}

output "sonarqube_prod_tags" {
  value = aws_instance.sonarqube_prod.tags
}
