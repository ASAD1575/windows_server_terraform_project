# Genrerate SSH Key Pair for EC2 Instances
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Create Key Pair for EC2 Instances
resource "aws_key_pair" "generated_key" {
  key_name   = "terraform_generated_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
    tags = {
    Name = "windows_instance_ssh_key"
  }
}

# Create Local File to store the private key
resource "local_file" "private_key_pem" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/ec2_key.pem"
  file_permission = "0600"
}