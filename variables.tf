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
  default     = "ami-028dc1123403bd543" # Example for us-east-1, update as needed
}

variable "base_instance_type" {
  description = "Instance type for the base instance"
  type        = string
  default     = "t2.micro"
}

variable "cloned_instance_count" {
  description = "Number of cloned instances to create"
  type        = number
  default     = 1
}

variable "cloned_instance_type" {
  description = "Instance type for the cloned instances"
  type        = string
  default     = "t2.micro"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket for storing scripts and state"
  type        = string
  default     = "windows-server-tfstate-bucket"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "windows-server-tfstate-lock"
}

variable "base_instance_name" {
  description = "The name tag for the base instance"
  type        = string
  default     = "Base_Image_Instance"
  
}

variable "clone_instance_name" {
  description = "The name tag for the cloned instances"
  type        = string
  default     = "Cloned-Instance"
  
}