# The number of cloned instances to create.
variable "cloned_instance_count" {
  description = "The number of cloned instances to create."
  type        = number
}

# The AMI ID for the cloned instances.
variable "ami_id" {
  description = "The ID of the AMI for the cloned instances."
  type        = string
}

# The instance type (e.g., "t2.micro").
variable "instance_type" {
  description = "The instance type."
  type        = string
}

# The subnet to launch the instances in.
variable "subnet_id" {
  description = "The subnet ID to launch the instances in."
  type        = string
}

# The security group to apply to the instances.
variable "security_group_id" {
  description = "The ID of the security group to attach to the instances."
  type        = string
}

# The key pair name for SSH access.
variable "key_name" {
  description = "The key pair name for SSH access."
  type        = string
}

# The IAM role for SSM connection 
variable "iam_instance_profile" {
  description = "Define iam role"
  type = string
}

variable "cloned_instance_name" {
  description = "The name tag for the cloned instances"
  type        = string
  
}

variable "env" {
  description = "Environment (e.g., dev, prod)"
  type        = string
  
}