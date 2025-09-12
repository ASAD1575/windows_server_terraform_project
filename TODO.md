# TODO List for Windows Server Terraform Project

## Task: Implement base instance creation with Windows Server, fetch script from S3 to install browsers and set startup, create AMI, then use AMI for cloned instances.

### Steps:
1. **Add S3 bucket object to upload PowerShell script**: Modify or add resources to upload `userdata/windows_setup.ps1` to the S3 bucket created in modules/S3.
2. **Update base_instance user_data**: Change user_data in `modules/base_instance/main.tf` to download the script from S3 and execute it instead of using the local file.
3. **Verify IAM role permissions**: Ensure the IAM role in `modules/IAM_role/main.tf` has S3 read access (already has AmazonS3ReadOnlyAccess).
4. **Confirm WinRM connection**: Verify that the null_resource in `main.tf` uses the decrypted password from `module.base_instance.password_data` for WinRM connection.
5. **Test and validate the workflow**: Ensure the script installs browsers, sets startup, creates flag, AMI is created, and cloned instances launch correctly.
6. **Update TODO as steps complete**.

### Completed:
- [x] Analyze project structure and gather information.
- [x] Create initial plan and get user approval.
- [x] Add S3 bucket object to upload PowerShell script.
- [x] Update base_instance user_data to fetch script from S3.
- [x] Verify IAM role permissions.
- [x] Confirm WinRM connection uses decrypted password.
- [x] Test and validate the workflow: Ensure the script installs browsers, sets startup, creates flag, AMI is created, and cloned instances launch correctly.
