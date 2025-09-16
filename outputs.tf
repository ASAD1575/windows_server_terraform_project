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