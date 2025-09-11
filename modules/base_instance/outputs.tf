# The ID of the base instance.
output "instance_id" {
  description = "The ID of the base instance."
  value       = aws_instance.base_instance.id
}
