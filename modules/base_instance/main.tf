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
EOT

  # --- Provisioner to install browsers and set them for startup ---
  provisioner "remote-exec" {
    # This connection block specifies how to connect to the instance using WinRM
    connection {
      type     = "winrm"
      user     = "Administrator"
      password = data.aws_ec2_password.admin_password.password
      host     = self.public_ip
      insecure = true # WARNING: for demo only, disable in production
    }
    # The actual PowerShell script to execute
    inline = [
      "Set-ExecutionPolicy RemoteSigned -Force",
      "& './${path.module}/browser_installation_script.ps1'"
    ]
  }
}

# This data source decrypts the administrator password using the private key file.
data "aws_ec2_password" "admin_password" {
  instance_id = aws_instance.base_instance.id
  private_key = file("${path.module}/../key_pair/ec2_key.pem")

}
