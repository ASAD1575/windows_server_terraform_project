# The ID of the source EC2 instance to create the AMI from.
variable "source_instance_id" {
  description = "The ID of the source EC2 instance to create the AMI from."
  type        = string
}

variable "env" {
  description = "Environment (e.g., dev, prod)"
  type        = string
  
}