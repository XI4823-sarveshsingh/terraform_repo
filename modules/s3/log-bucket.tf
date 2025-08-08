resource "aws_s3_bucket" "log_bucket" {
  count  = var.enable_logging ? 1 : 0
  bucket = "${var.name}-log-bucket"
}
resource "aws_s3_bucket_versioning" "log_bucket_versioning" {
  count                 = var.enable_logging && var.enable_versioning ? 1 : 0
  bucket                = aws_s3_bucket.log_bucket[0].id
  expected_bucket_owner = data.aws_caller_identity.current.account_id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_logging" "this" {
  count         = var.enable_logging ? 1 : 0
  bucket        = aws_s3_bucket.this.id
  target_bucket = aws_s3_bucket.log_bucket[0].id
  target_prefix = "log/"
}
resource "aws_s3_bucket_public_access_block" "log_bucket" {
  count                   = var.enable_logging ? 1 : 0
  bucket                  = aws_s3_bucket.log_bucket[0].id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
resource "aws_s3_bucket_server_side_encryption_configuration" "log_bucket" {
  count  = var.enable_logging ? 1 : 0
  bucket = aws_s3_bucket.log_bucket[0].id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}