variable "vpc_cidr_block" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }
variable "env" {
  description = "Environment (e.g., dev, prod)"
  type        = string
  
}
