variable "aws_region" { 
  type = string
}
variable "vpc_cidr_block" { type = string }
variable "public_subnets" { type = list(string) }
variable "private_subnets" { type = list(string) }
variable "azs" { type = list(string) }