output "base_log_group_name" {
  description = "Name of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.ec2_base_log_group.name
}

output "cloned_log_group_name" {
  description = "ARN of the CloudWatch Log Group"
  value       = aws_cloudwatch_log_group.ec2_clone_log_group.name
}
