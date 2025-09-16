provider "aws" {
  region = var.region

}

resource "aws_s3_bucket" "windows_server_bucket" {
  bucket = var.bucket_name

  tags = {
    Name = "${var.bucket_name}-${var.env}"
  }

}

# Upload the PowerShell script to S3 bucket
resource "aws_s3_object" "windows_setup_script" {
  bucket = aws_s3_bucket.windows_server_bucket.id
  key    = "windows_setup.ps1"
  source = "${path.module}/../../userdata/windows_setup.ps1"
}

resource "aws_s3_bucket_public_access_block" "windows_server_bucket_pub" {
  bucket = aws_s3_bucket.windows_server_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false

}

# resource "aws_dynamodb_table" "windows_server_tfstate_lock_table" {
#   name           = var.aws_dynamodb_table_name
#   billing_mode   = "PROVISIONED"
#   read_capacity  = 5
#   write_capacity = 5

#   hash_key = "LockID"

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name = "windows-server-tfstate-lock-table1575"
#   }

# }
