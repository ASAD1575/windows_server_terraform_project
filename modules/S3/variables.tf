variable "region" {
  description = "AWS region where the S3 bucket will be created"
  type        = string
  
}

variable "bucket_name" {
  description = "Name of the S3 bucket to store Terraform state"
  type        = string
  
}

variable "aws_dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  
}

variable "env" {
  description = "Environment (e.g., dev, prod)"
  type        = string
  
}