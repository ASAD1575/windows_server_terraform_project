variable "region" {
  type        = string
  description = "AWS region"
}

variable "environment" {
  type        = string
  description = "Environment (e.g., dev, prod)"
}

variable "log_retention_in_days" {
  type        = number
  description = "Number of days to retain logs"
  default     = 7
}

variable "base_instance_name" {
  type        = string
  description = "Name for the base EC2 instance log group"
}

variable "clone_instance_name" {
  type        = string
  description = "Name for the cloned EC2 instance log group"
}
