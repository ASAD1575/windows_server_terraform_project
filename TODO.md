# TODO List for Terraform Windows Server Infrastructure

## 1. Update root main.tf
- Fix module calls to base_instance with correct variable names (subnet_id, key_name)
- Add key_pair module call
- Add ami_creation module call with depends_on base_instance
- Add cloned_instance module call with depends_on ami_creation

## 2. Update root variables.tf
- Add variables for windows_server_2022_ami_id, base_instance_type, cloned_instance_count, cloned_instance_type

## 3. Update root outputs.tf
- Add outputs for base_instance_id, ami_id, cloned_instance_ids

## 4. Edit modules/base_instance/main.tf
- Fix resource name to aws_instance.base_instance
- Use subnet_id and key_name variables
- Add user_data to run browser installation script
- Use remote-exec provisioner with WinRM to run the script
- Add data source aws_ec2_password to get admin password

## 5. Edit modules/base_instance/variables.tf
- Use subnet_id and key_name variables

## 6. Edit modules/base_instance/outputs.tf
- Output instance_id from aws_instance.base_instance

## 7. Edit modules/cloned_instance/outputs.tf
- Add output for cloned instance IDs

## 8. Ensure browser installation script is PowerShell (.ps1)
- Rename browser_installation_script to .ps1 if needed
