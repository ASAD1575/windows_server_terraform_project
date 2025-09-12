output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.windows_server_tfstate_bucket.id
}

output "script_object_key" {
  description = "The key of the uploaded PowerShell script"
  value       = aws_s3_object.windows_setup_script.key
}
