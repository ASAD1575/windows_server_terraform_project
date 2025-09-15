# Windows Server Terraform Project

## Project Description

This project provides a Terraform configuration to provision and manage Windows Server 2022 instances on AWS. It automates the creation of the necessary AWS infrastructure including VPC, subnets, security groups, IAM roles, key pairs, and S3 buckets. The project also automates the deployment of a base Windows Server instance, installs browsers via a PowerShell script, creates a custom AMI from the base instance, and launches cloned instances from the custom AMI.

## Features

- Automated AWS infrastructure provisioning using Terraform modules
- VPC with public and private subnets
- Security groups configured for HTTP, HTTPS, RDP, and WinRM access
- IAM roles with appropriate permissions for EC2 instances
- S3 bucket for storing user data scripts
- Base Windows Server 2022 instance setup with browser installations (Chrome, Firefox, Edge)
- Custom AMI creation from the base instance
- Cloned instances launched from the custom AMI
- Automated readiness checks using AWS SSM and custom scripts

## Prerequisites
- AWS account with appropriate permissions
- Terraform installed (version compatible with AWS provider ~> 6.13.0)
- AWS CLI installed and configured
- PowerShell for Windows script execution (for local testing if needed)

## Terraform Backend Configuration
The project uses an S3 backend for storing Terraform state files and DynamoDB for state locking to ensure safe concurrent access. Ensure you have an S3 bucket and DynamoDB table created, or update the backend configuration in `main.tf` with your own bucket and table names. The default bucket name is `my-terraform-state-bucket` and DynamoDB table name is based on the `dynamodb_table_name` variable.

## Architecture Overview
The project is structured into multiple Terraform modules, each responsible for a specific part of the infrastructure:

- **VPC Module:** Creates a VPC with public and private subnets, internet gateway, and route tables.
- **Security Group Module:** Defines security groups allowing HTTP, HTTPS, RDP, and WinRM traffic.
- **IAM Role Module:** Creates IAM roles and instance profiles with permissions for SSM and S3 read access.
- **Key Pair Module:** Generates an SSH key pair for EC2 instances.
- **S3 Module:** Creates an S3 bucket and uploads the Windows setup PowerShell script.
- **Base Instance Module:** Launches a base Windows Server instance, installs AWS SSM agent, AWS CLI, downloads and runs the browser installation script from S3.
- **AMI Creation Module:** Creates a custom AMI from the configured base instance.
- **Cloned Instance Module:** Launches cloned instances from the custom AMI.
- **CloudWatch Module:** Creates CloudWatch log groups for logging from the base and cloned instances.

## Usage Instructions

1. **Initialize Terraform:**

   ```bash
   terraform init
   ```

2. **Review the Terraform plan:**

   ```bash
   terraform plan
   ```

3. **Apply the Terraform configuration:**

   ```bash
   terraform apply
   ```

4. **Destroy the infrastructure when no longer needed:**
   ```bash
   terraform destroy
   ```

## Variables
The project uses several variables defined in `variables.tf` and configured in `terraform.tfvars`:

- `aws_region`: AWS region to deploy resources (e.g., us-east-1)
- `vpc_cidr_block`: CIDR block for the VPC
- `public_subnets`: List of CIDR blocks for public subnets
- `private_subnets`: List of CIDR blocks for private subnets
- `azs`: Availability zones for subnets
- `windows_server_2022_ami_id`: Base AMI ID for Windows Server 2022
- `base_instance_type`: EC2 instance type for the base instance
- `cloned_instance_count`: Number of cloned instances to create
- `cloned_instance_type`: EC2 instance type for cloned instances
- `s3_bucket_name`: Name of the S3 bucket for storing scripts
- `dynamodb_table_name`: Name of the DynamoDB table for state locking
- `base_instance_name`: Name tag for the base instance
- `clone_instance_name`: Name tag for the cloned instances

## Outputs

The following outputs are available after Terraform apply:

- `base_instance_id`: ID of the base Windows Server instance
- `base_instance_public_ip`: Public IP of the base instance
- `custom_ami_id`: ID of the custom AMI created from the base instance
- `cloned_instance_ids`: IDs of the cloned instances
- `cloned_instance_public_ips`: Public IPs of the cloned instances

## Scripts

### userdata/windows_setup.ps1
PowerShell script that installs Google Chrome, Mozilla Firefox, and Microsoft Edge browsers on the Windows Server instance. It also adds these browsers to the Windows startup registry and creates a flag file to indicate installation completion. This script is uploaded to the S3 bucket and executed on the base instance during provisioning.

### wait_for_flag.sh
Bash script that waits for the base instance to be running, the AWS SSM agent to be online, and the installation flag file to be present on the instance before proceeding. This ensures the base instance is fully configured before creating the AMI. It is executed as a local-exec provisioner in Terraform to synchronize the AMI creation process.

## Contributing
Contributions are welcome. Please fork the repository and submit pull requests for any improvements or bug fixes.

## License

This project is licensed under the MIT License.
