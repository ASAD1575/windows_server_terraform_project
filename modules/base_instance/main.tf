resource "aws_instance" "windows_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnet_ids, 0)
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true

  tags = {
    Name = "Windows-Server-Instance-temp"
  }
  
}

null_resource "wait_for_instance" {
  provisioner "local-exec" {
    command = "echo Waiting for instance to be in 'running' state... && aws ec2 wait instance-running --instance-ids ${aws_instance.windows_instance.id} --region ${var.aws_region} && echo Instance is running."
  }
  
  depends_on = [aws_instance.windows_instance]
}