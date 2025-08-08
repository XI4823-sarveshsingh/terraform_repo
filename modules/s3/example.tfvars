region                     = "ap-south-1"
name                       = "my-test-xxx"
kms_key_id                 = "arn:aws:kms:ap-south-1:47xxx:key/7e2xxx-d9b3-42a8-802b-xxxxx"
enable_intelligent_tiering = true

cors_rules = [{
  allowed_headers = ["*"],
  allowed_methods = ["PUT", "POST"],
  allowed_origins = ["*"],
  expose_headers  = ["ETag"],
  max_age_seconds = 3600
  },
]

enable_lifecycle_configuration = true

lifecycle_rule = [{
  id     = "tmp"
  status = "Enabled"
  abort_incomplete_multipart_upload = {
    abort_incomplete_multipart_upload_days = 3
  }
  expiration = {
    date = "2024-01-13T00:00:00Z"
  }
  filter = {
    prefix = "tmp/"
  }
  noncurrent_version_expiration = {
    noncurrent_days = 90
  }
  noncurrent_version_transition = {
    noncurrent_days = 30
    storage_class   = "STANDARD_IA"
  }
  },
]

attach_policy = true
policy_path   = "policy/test.json"
policy_vars = {
  bucket_name = "my-test-xxx"
}

enable_object_lock = false
object_ownership   = "BucketOwnerPreferred"

replication_configuration = {
  rules = [
    {
      id                        = "abc"
      priority                  = 20
      delete_marker_replication = false
      destination = {
        storage_class      = "STANDARD"
        replica_kms_key_id = "arn:aws:kms:ap-south-1:47xxx:key/7e2xxx-d9b3-42a8-802b-xxxxx"
      }
      source_selection_criteria = {
        replica_modifications = {
          status = "Enabled"
        }
        sse_kms_encrypted_objects = {
          enabled = true
        }
      }
    },
  ]
}
