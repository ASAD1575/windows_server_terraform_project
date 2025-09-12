# Define the EC2 instance resource with the IAM role
resource "aws_instance" "base_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnet_ids, 0)
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile  # Attach IAM instance profile
  get_password_data           = true  # Enable password retrieval for Windows instances
  tags = {
    Name = "Base_Image_Instance"
  }

  user_data = file("${path.module}/../../userdata/windows_setup.ps1")  # Run Windows setup script
}

# Create SSM document to run the setup script (Optional, if you want to execute script via SSM)
resource "aws_ssm_document" "run_setup_script" {
  name          = "RunWindowsSetupScript"
  document_type = "Command"

  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Run Windows setup script"
    mainSteps = [
      {
        action = "aws:runPowerShellScript"
        name   = "runShellScript"
        inputs = {
          runCommand = [
            "C:\\Windows\\Temp\\windows_setup.ps1"  # Ensure this script path is correct on the instance
          ]
        }
      }
    ]
  })
}

# Associate the SSM document with the base instance (Optional)
resource "aws_ssm_association" "run_windows_setup" {
  name = aws_ssm_document.run_setup_script.name
  targets {
    key    = "instanceids"
    values = [aws_instance.base_instance.id]
  }
}
