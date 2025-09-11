# The ID of the custom AMI.
output "ami_id" {
  description = "The ID of the custom AMI."
  value       = aws_ami_from_instance.app_ami.id
}
