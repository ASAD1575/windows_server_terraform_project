# Base instance outputs
output "base_instance_id" {
  description = "The ID of the base instance."
  value       = module.base_instance.instance_id
}

output "base_instance_public_ip" {
  description = "The public IP of the base instance."
  value       = module.base_instance.public_ip
}

# AMI outputs
output "custom_ami_id" {
  description = "The ID of the custom AMI created from the base instance."
  value       = module.ami_creation.ami_id
}

# Cloned instances outputs
output "cloned_instance_ids" {
  description = "The IDs of the cloned instances."
  value       = module.cloned_instance.instance_ids
}

output "cloned_instance_public_ips" {
  description = "The public IPs of the cloned instances."
  value       = module.cloned_instance.public_ips
}

output "cloudwatch_base_log_group_name" {
  description = "Name of the CloudWatch Log Group for Base Instance"
  value       = module.cloudwatch.base_log_group_name
  
}

output "cloudwatch_cloned_log_group_name" {
  description = "Name of the CloudWatch Log Group for Cloned Instance"
  value       = module.cloudwatch.cloned_log_group_name
}