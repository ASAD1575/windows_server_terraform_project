# Define the EC2 instance resource
resource "aws_instance" "base_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnet_ids, 0)
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true
  get_password_data           = true
  tags = {
    Name = "Base_Image_Instance"
  }

  # User data to enable WinRM, which is required for the provisioner to work.
  user_data = <<-EOT
<powershell>
  winrm quickconfig -q
  winrm set winrm/config/service/Auth @{Basic="true"}
  winrm set winrm/config/service/Auth @{CredSSP="true"}
  winrm set winrm/config/service/Auth @{Negotiate="true"}
  winrm set winrm/config/service/Auth @{Kerberos="true"}
  Set-Service -Name WinRM -StartupType Automatic
  Start-Service -Name WinRM
  netsh advfirewall firewall add rule name="WinRM-in" dir=in action=allow protocol=TCP localport=5985
</powershell>
<powershell>
  # This part is the content of your browser_installation_script.ps1 file.
  # The file is executed automatically at the time the instance launches.
${file("${path.module}/browser_installation_script.ps1")}
</powershell>
EOT
}

# This `null_resource` is a crucial step to ensure the AMI creation
# doesn't happen until the script is fully executed.
resource "null_resource" "wait_for_script" {
  # This makes the null resource depend on the base instance.
  depends_on = [aws_instance.base_instance]

  # This provisioner waits until a file created by the script exists.
  provisioner "remote-exec" {
    inline = [
      "Wait-For-File -Path 'C:\\completed_browsers_install.txt'",
    ]
    connection {
      type        = "winrm"
      user        = "Administrator"
      password    = var.instance_password
      host        = aws_instance.base_instance.public_ip
    }
  }
}

# --- Null resource to terminate the base instance after AMI creation ---
resource "null_resource" "terminate_base_instance" {
  # This resource will not be created until after the AMI is successfully built.
  # Replace 'aws_ami_from_instance.ami_creation' with the name of your actual AMI resource.
  depends_on = [
    aws_ami_from_instance.ami_creation
  ]

  # The provisioner that executes a command on your local machine.
  provisioner "local-exec" {
    command = "aws ec2 terminate-instances --instance-ids ${aws_instance.base_instance.id}"
    interpreter = [ "bash", "-c" ]
  }
}