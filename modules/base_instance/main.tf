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
      password = self.password_data # Access the decrypted password
      host     = self.public_ip
      insecure = true # WARNING: for demo only, disable in production
    }



    # The actual PowerShell script to execute

    inline = [

      "Set-ExecutionPolicy RemoteSigned -Force",

      "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/microsoft/winget-cli/master/LICENSE' -OutFile 'C:\\browser_install.ps1'",

      # Add the browser installation script content here or download it

      "Write-Host 'Installing browsers...'",

      "winget install --id Google.Chrome -e --accept-package-agreements --silent",

      "winget install --id Mozilla.Firefox -e --accept-package-agreements --silent",

      "winget install --id Microsoft.Edge -e --accept-package-agreements --silent",

      # Set browsers to run on startup

      "$action = New-ScheduledTaskAction -Execute 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe'",

      "$trigger = New-ScheduledTaskTrigger -AtStartup",

      "Register-ScheduledTask -TaskName 'LaunchChrome' -Action $action -Trigger $trigger -User 'SYSTEM'",

      "$action = New-ScheduledTaskAction -Execute 'C:\\Program Files\\Mozilla Firefox\\firefox.exe'",

      "Register-ScheduledTask -TaskName 'LaunchFirefox' -Action $action -Trigger $trigger -User 'SYSTEM'",

      "$action = New-ScheduledTaskAction -Execute 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe'",

      "Register-ScheduledTask -TaskName 'LaunchEdge' -Action $action -Trigger $trigger -User 'SYSTEM'"

    ]

  }

}




