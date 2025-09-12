# Define the EC2 instance resource with the IAM role
resource "aws_instance" "base_instance" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.public_subnet_ids, 0)
  vpc_security_group_ids      = [var.security_group_id]
  key_name                    = var.key_pair_name
  associate_public_ip_address = true
  iam_instance_profile        = var.iam_instance_profile # Attach IAM instance profile
  get_password_data           = true                     # Enable password retrieval for Windows instances
  tags = {
    Name = "Base_Image_Instance"
  }

  user_data = <<-EOF
    <powershell>
    # Enable WinRM and configure the firewall
    Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*"
    Enable-PSRemoting -Force
    New-NetFirewallRule -Name "WinRM HTTP" -DisplayName "WinRM HTTP" -Enabled True -Protocol TCP -Action Allow -LocalPort 5985
    New-NetFirewallRule -Name "WinRM HTTPS" -DisplayName "WinRM HTTPS" -Enabled True -Protocol TCP -Action Allow -LocalPort 5986

    # Install AWS CLI v2
    $installerUrl = "https://awscli.amazonaws.com/AWSCLIV2.msi"
    $installerPath = "C:\Windows\Temp\AWSCLIV2.msi"
    Invoke-WebRequest $installerUrl -OutFile $installerPath -UseBasicParsing
    Start-Process msiexec.exe -ArgumentList "/i `"$installerPath`" /qn /norestart" -Wait

    # Give installer time to finish
    Start-Sleep -Seconds 20

    # Add AWS CLI path for this session
    $env:Path += ";C:\Program Files\Amazon\AWSCLIV2\"

    # Configure AWS CLI default region
    aws configure set region us-east-1

    # Download the setup script from S3
    $bucket = "${var.s3_bucket_id}"
    $key = "windows_setup.ps1"
    Write-Host "Downloading script from s3://$bucket/$key"
    aws s3 cp "s3://$bucket/$key" "C:\Windows\Temp\windows_setup.ps1"
    Write-Host "Download complete"

    # Run the setup script
    & "C:\Windows\Temp\windows_setup.ps1"
    </powershell>
  EOF
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
            "C:\\Windows\\Temp\\windows_setup.ps1" # Ensure this script path is correct on the instance
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
    key    = "InstanceIds"
    values = [aws_instance.base_instance.id]
  }
}
