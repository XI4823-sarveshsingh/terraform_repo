data "aws_iam_policy_document" "replication" {
  count = var.enable_replication ? 1 : 0
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
      "s3:ReplicateObject",
      "s3:ReplicateTags",
      "s3:GetObjectVersionTagging",
      "s3:ReplicateDelete"
    ]
    resources = [aws_s3_bucket.this.arn]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
    ]
    resources = ["${aws_s3_bucket.this.arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:ObjectOwnerOverrideToBucketOwner",
      "s3:GetObjectVersionTagging",
    ]
    resources = ["${aws_s3_bucket.replication-bucket[0].arn}/*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey",
      "kms:Encrypt"
    ]
    resources = [var.kms_key_id]
  }
}

resource "aws_iam_role" "replication" {
  count              = var.enable_replication ? 1 : 0
  name               = "${var.name}-iam-role-replication"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_policy" "replication" {
  count  = var.enable_replication ? 1 : 0
  name   = "${var.name}-iam-role-policy-replication"
  policy = data.aws_iam_policy_document.replication[0].json
}
resource "aws_iam_role_policy_attachment" "replication" {
  count      = var.enable_replication ? 1 : 0
  role       = aws_iam_role.replication[0].name
  policy_arn = aws_iam_policy.replication[0].arn
}
resource "aws_s3_bucket" "replication-bucket" {
  count  = var.enable_replication ? 1 : 0
  bucket = "${var.name}-replica-s3-bucket"
}
resource "aws_s3_bucket_versioning" "destination" {
  count  = var.enable_replication && var.enable_versioning ? 1 : 0
  bucket = aws_s3_bucket.replication-bucket[0].id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "replication-bucket" {
  count  = var.enable_replication ? 1 : 0
  bucket = aws_s3_bucket.replication-bucket[0].id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "replication-bucket" {
  count                   = var.enable_replication ? 1 : 0
  bucket                  = aws_s3_bucket.replication-bucket[0].id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}