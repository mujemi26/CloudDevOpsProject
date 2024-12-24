output "cloudwatch_alarm_arn" {
  description = "ARN of the CloudWatch Alarm"
  value       = aws_cloudwatch_metric_alarm.cpu_alarm.arn
}

output "sns_topic_arn" {
  description = "ARN of the SNS Topic"
  value       = aws_sns_topic.alerts.arn
}

output "alarm_actions" {
  description = "List of actions to be taken when alarm triggers"
  value       = aws_cloudwatch_metric_alarm.cpu_alarm.alarm_actions
}