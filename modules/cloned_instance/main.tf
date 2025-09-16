# This module creates cloned EC2 instances from the custom AMI.

resource "aws_instance" "cloned_instance" {
  count                       = var.cloned_instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile  # Attach IAM instance profile
  associate_public_ip_address = true
  tags = {
    Name = "${var.cloned_instance_name}-${count.index + 1}-${var.env}"
  }

  # This lifecycle rule ensures the new instance is created before the old one is destroyed.
  # Terraform will first provision the `final_instance` and then terminate the `provisioning_instance`.
  lifecycle {
    create_before_destroy = true
  }
}
