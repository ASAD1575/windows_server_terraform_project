variable "aws_region" {
  type = string
}
variable "vpc_cidr_block" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }

# Windows Server 2022 AMI ID (update with actual AMI ID for your region)
variable "windows_server_2022_ami_id" {
  description = "AMI ID for Windows Server 2022"
  type        = string
  default     = "ami-0c02fb55956c7d316"  # Example for us-east-1, update as needed
}

variable "base_instance_type" {
  description = "Instance type for the base instance"
  type        = string
  default     = "t3.medium"
}

variable "cloned_instance_count" {
  description = "Number of cloned instances to create"
  type        = number
  default     = 8
}

variable "cloned_instance_type" {
  description = "Instance type for the cloned instances"
  type        = string
  default     = "t3.medium"
}
