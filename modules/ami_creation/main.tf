# This module creates a new AMI (Amazon Machine Image) from an existing EC2 instance.

resource "aws_ami_from_instance" "app_ami" {
  name               = "custom-ami-${formatdate("YYYY-MM-DD-hh-mm-ss", timestamp())}"
  source_instance_id = var.source_instance_id
  tags = {
    Name = "custom-ami"
  }
}
