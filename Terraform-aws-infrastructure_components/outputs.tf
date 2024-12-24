# Root outputs.tf (in the main directory)
output "vpc" {
  description = "VPC outputs"
  value = {
    vpc_id            = module.vpc.vpc_id
    private_subnets   = module.vpc.private_subnet_ids
    public_subnets    = module.vpc.public_subnet_ids
    nat_gateway_ip    = module.vpc.nat_gateway_ip
    vpc_cidr_block    = module.vpc.vpc_cidr_block
    vpc_public_subnet_cidr_blocks = module.vpc.public_subnet_cidr_blocks
  }
}

output "security" {
  description = "Security group outputs"
  value = {
    security_group_id   = module.security.app_security_group_id
    security_group_name = module.security.app_security_group_name
    security_rules     = module.security.app_security_group_rules
  }
}

output "ec2" {
  value = {
    jenkins_dev = {
      instance_id       = module.ec2.jenkins_dev_instance_id
      private_ip       = module.ec2.jenkins_dev_private_ip
      public_ip        = module.ec2.jenkins_dev_public_ip
      availability_zone = module.ec2.jenkins_dev_az
      instance_state   = module.ec2.jenkins_dev_state
      instance_tags    = module.ec2.jenkins_dev_tags
    }
    jenkins_prod = {
      instance_id       = module.ec2.jenkins_prod_instance_id
      private_ip       = module.ec2.jenkins_prod_private_ip
      public_ip        = module.ec2.jenkins_prod_public_ip
      availability_zone = module.ec2.jenkins_prod_az
      instance_state   = module.ec2.jenkins_prod_state
      instance_tags    = module.ec2.jenkins_prod_tags
    }
    sonarqube_dev = {
      instance_id       = module.ec2.sonarqube_dev_instance_id
      private_ip       = module.ec2.sonarqube_dev_private_ip
      public_ip        = module.ec2.sonarqube_dev_public_ip
      availability_zone = module.ec2.sonarqube_dev_az
      instance_state   = module.ec2.sonarqube_dev_state
      instance_tags    = module.ec2.sonarqube_dev_tags
    }
    sonarqube_prod = {
      instance_id       = module.ec2.sonarqube_prod_instance_id
      private_ip       = module.ec2.sonarqube_prod_private_ip
      public_ip        = module.ec2.sonarqube_prod_public_ip
      availability_zone = module.ec2.sonarqube_prod_az
      instance_state   = module.ec2.sonarqube_prod_state
      instance_tags    = module.ec2.sonarqube_prod_tags
    }
  }
}


output "monitoring" {
  value = {
    jenkins_dev = {
      alarm_arn     = module.monitoring_jenkins_dev.cloudwatch_alarm_arn
      sns_topic_arn = module.monitoring_jenkins_dev.sns_topic_arn
      alarm_actions = module.monitoring_jenkins_dev.alarm_actions
    }
    jenkins_prod = {
      alarm_arn     = module.monitoring_jenkins_prod.cloudwatch_alarm_arn
      sns_topic_arn = module.monitoring_jenkins_prod.sns_topic_arn
      alarm_actions = module.monitoring_jenkins_prod.alarm_actions
    }
    sonarqube_dev = {
      alarm_arn     = module.monitoring_sonarqube_dev.cloudwatch_alarm_arn
      sns_topic_arn = module.monitoring_sonarqube_dev.sns_topic_arn
      alarm_actions = module.monitoring_sonarqube_dev.alarm_actions
    }
    sonarqube_prod = {
      alarm_arn     = module.monitoring_sonarqube_prod.cloudwatch_alarm_arn
      sns_topic_arn = module.monitoring_sonarqube_prod.sns_topic_arn
      alarm_actions = module.monitoring_sonarqube_prod.alarm_actions
    }
  }
}
