provider "aws" {
  region = var.region
  
}

resource "aws_s3_bucket" "mutitier_app_tfstate_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
  }
  
}

resource "aws_s3_bucket_public_access_block" "mutitier_app_tfstate_bucket_pab" {
  bucket = aws_s3_bucket.mutitier_app_tfstate_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  
}

resource "aws_dynamodb_table" "mutitier_app_tfstate_lock_table" {
  name         = var.aws_dynamodb_table_name
  billing_mode = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "multitier-app-tfstate-lock-table1575"
  }
  
}