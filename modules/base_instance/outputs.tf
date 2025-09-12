# The ID of the base instance.
output "instance_id" {
  description = "The ID of the base instance."
  value       = aws_instance.base_instance.id
}

# The public IP of the base instance.
output "public_ip" {
  description = "The public IP of the base instance."
  value       = aws_instance.base_instance.public_ip
}

# The password data for the Windows instance.
output "password_data" {
  description = "The password data for the Windows instance."
  value       = aws_instance.base_instance.password_data
  sensitive   = true
}

