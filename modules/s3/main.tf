# provider "aws" {
#   region = var.region
#   default_tags {
#     tags = var.common_tags
#   }
#   assume_role {
#     role_arn = var.assume_role_arn
#   }
# }
#####################################################################################
# data blocks
#####################################################################################
data "aws_caller_identity" "current" {}
data "aws_iam_policy_document" "combined" {
  count = var.attach_deny_insecure_transport_policy || var.attach_policy ? 1 : 0
  source_policy_documents = compact([
    var.attach_deny_insecure_transport_policy ? data.aws_iam_policy_document.deny_insecure_transport[0].json : "",
    var.attach_policy ? data.template_file.policy_document[0].rendered : ""
  ])
}
data "template_file" "policy_document" {
  count    = var.attach_policy ? 1 : 0
  template = file("${path.root}//${var.policy_path}")
  vars     = var.policy_vars
}
data "aws_iam_policy_document" "deny_insecure_transport" {
  count = var.attach_deny_insecure_transport_policy ? 1 : 0
  statement {
    sid    = "denyInsecureTransport"
    effect = "Deny"
    actions = [
      "s3:*",
    ]
    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }
}
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
#####################################################################################
# S3 Bucket
#####################################################################################
resource "aws_s3_bucket" "this" {
  bucket              = var.name
  force_destroy       = var.enable_force_destroy
  object_lock_enabled = var.enable_object_lock
}
resource "aws_s3_bucket_accelerate_configuration" "this" {
  count                 = var.enable_acceleration_status ? 1 : 0
  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = data.aws_caller_identity.current.account_id
  status                = "Enabled"
}
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = var.object_ownership
  }
}
resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}
resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this, aws_s3_bucket_public_access_block.this]
  bucket     = aws_s3_bucket.this.id
  acl        = var.acl
}
resource "aws_s3_bucket_cors_configuration" "this" {
  count                 = var.enable_cors_config ? 1 : 0
  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = data.aws_caller_identity.current.account_id
  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      id              = try(cors_rule.value.id, null)
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = try(cors_rule.value.allowed_headers, null)
      expose_headers  = try(cors_rule.value.expose_headers, null)
      max_age_seconds = try(cors_rule.value.max_age_seconds, null)
    }
  }
}
resource "aws_s3_bucket_intelligent_tiering_configuration" "this" {
  for_each = var.enable_intelligent_tiering ? { for k, v in var.intelligent_tiering : k => v } : {}
  name     = "${var.name}-tiering-conf"
  bucket   = aws_s3_bucket.this.id
  status   = try(tobool(each.value.status) ? "Enabled" : "Disabled", title(lower(each.value.status)), null)
  dynamic "filter" {
    for_each = length(try(flatten([each.value.filter]), [])) == 0 ? [] : [true]
    content {
      prefix = try(each.value.filter.prefix, null)
      tags   = try(each.value.filter.tags, null)
    }
  }
  dynamic "tiering" {
    for_each = each.value.tiering
    content {
      access_tier = tiering.key
      days        = tiering.value.days
    }
  }
}
#####################################################################################
# S3 Lifecycle Config
#####################################################################################
resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count                 = var.enable_lifecycle_configuration ? 1 : 0
  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = data.aws_caller_identity.current.account_id
  dynamic "rule" {
    for_each = var.lifecycle_rule
    content {
      id     = rule.value.id
      status = rule.value.status
      # Max 1 block - abort_incomplete_multipart_upload
      dynamic "abort_incomplete_multipart_upload" {
        for_each = try([rule.value.abort_incomplete_multipart_upload], [])
        content {
          days_after_initiation = try(abort_incomplete_multipart_upload.value.abort_incomplete_multipart_upload_days, null)
        }
      }
      # Max 1 block - expiration
      dynamic "expiration" {
        for_each = try(flatten([rule.value.expiration]), [])
        content {
          date = try(expiration.value.date, null)
          days = try(expiration.value.days, null)
        }
      }
      # Several blocks - transition
      dynamic "transition" {
        for_each = try(flatten([rule.value.transition]), [])
        content {
          date          = try(transition.value.date, null)
          days          = try(transition.value.days, null)
          storage_class = transition.value.storage_class
        }
      }
      # Max 1 block - noncurrent_version_expiration
      dynamic "noncurrent_version_expiration" {
        for_each = try(flatten([rule.value.noncurrent_version_expiration]), [])
        content {
          newer_noncurrent_versions = try(noncurrent_version_expiration.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_expiration.value.days, noncurrent_version_expiration.value.noncurrent_days, null)
        }
      }
      # Several blocks - noncurrent_version_transition
      dynamic "noncurrent_version_transition" {
        for_each = try(flatten([rule.value.noncurrent_version_transition]), [])
        content {
          newer_noncurrent_versions = try(noncurrent_version_transition.value.newer_noncurrent_versions, null)
          noncurrent_days           = try(noncurrent_version_transition.value.days, noncurrent_version_transition.value.noncurrent_days, null)
          storage_class             = noncurrent_version_transition.value.storage_class
        }
      }
      # Max 1 block - filter - without any key arguments or tags
      dynamic "filter" {
        for_each = length(try(flatten([rule.value.filter]), [])) == 0 ? [true] : []
        content {
          #          prefix = ""
        }
      }
      # Max 1 block - filter - with one key argument or a single tag
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) == 1]
        content {
          object_size_greater_than = try(filter.value.object_size_greater_than, null)
          object_size_less_than    = try(filter.value.object_size_less_than, null)
          prefix                   = try(filter.value.prefix, null)
          dynamic "tag" {
            for_each = try(filter.value.tags, filter.value.tag, [])
            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }
      # Max 1 block - filter - with more than one key arguments or multiple tags
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) > 1]
        content {
          and {
            object_size_greater_than = try(filter.value.object_size_greater_than, null)
            object_size_less_than    = try(filter.value.object_size_less_than, null)
            prefix                   = try(filter.value.prefix, null)
            tags                     = try(filter.value.tags, filter.value.tag, null)
          }
        }
      }
    }
  }
  # Must have bucket versioning enabled first
  depends_on = [aws_s3_bucket_versioning.this[0]]
}
#####################################################################################
# Bucket Versioning and encryption
#####################################################################################
resource "aws_s3_bucket_versioning" "this" {
  count                 = var.enable_versioning ? 1 : 0
  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = data.aws_caller_identity.current.account_id
  versioning_configuration {
    # Valid values: "Enabled" or "Suspended"
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.kms_key_id
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_website_configuration" "this" {
  count  = length(keys(var.website)) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id
  dynamic "index_document" {
    for_each = try([var.website["index_document"]], [])
    content {
      suffix = lookup(index_document.value, "suffix", "")
    }
  }
  dynamic "error_document" {
    for_each = try([var.website["error_document"]], [])
    content {
      key = lookup(error_document.value, "key", "")
    }
  }
  dynamic "redirect_all_requests_to" {
    for_each = try([var.website["redirect_all_requests_to"]], [])
    content {
      host_name = redirect_all_requests_to.value.host_name
      protocol  = try(redirect_all_requests_to.value.protocol, null)
    }
  }
  dynamic "routing_rule" {
    for_each = try(flatten([var.website["routing_rules"]]), [])
    content {
      dynamic "condition" {
        for_each = [try([routing_rule.value.condition], [])]
        content {
          http_error_code_returned_equals = try(routing_rule.value.condition["http_error_code_returned_equals"], null)
          key_prefix_equals               = try(routing_rule.value.condition["key_prefix_equals"], null)
        }
      }
      redirect {
        host_name               = try(routing_rule.value.redirect["host_name"], null)
        http_redirect_code      = try(routing_rule.value.redirect["http_redirect_code"], null)
        protocol                = try(routing_rule.value.redirect["protocol"], null)
        replace_key_prefix_with = try(routing_rule.value.redirect["replace_key_prefix_with"], null)
        replace_key_with        = try(routing_rule.value.redirect["replace_key_with"], null)
      }
    }
  }
}
resource "aws_s3_bucket_metric" "this" {
  for_each = { for k, v in var.metric_configuration : k => v }
  name     = "${var.name}-bucket-metric"
  bucket   = aws_s3_bucket.this.id
  dynamic "filter" {
    for_each = length(try(flatten([each.value.filter]), [])) == 0 ? [] : [true]
    content {
      prefix = try(each.value.filter.prefix, null)
      tags   = try(each.value.filter.tags, null)
    }
  }
}
#####################################################################################
# Provides an S3 bucket Object Lock configuration resource
#####################################################################################
resource "aws_s3_bucket_object_lock_configuration" "this" {
  count                 = var.enable_object_lock && try(var.object_lock_configuration.rule.default_retention, null) != null ? 1 : 0
  bucket                = aws_s3_bucket.this.id
  expected_bucket_owner = data.aws_caller_identity.current.account_id
  rule {
    default_retention {
      mode = var.object_lock_configuration.rule.default_retention.mode
      days = try(var.object_lock_configuration.rule.default_retention.days, null)
    }
  }
}
#####################################################################################
# Attaches a policy to an S3 bucket resource
#####################################################################################
resource "aws_s3_bucket_policy" "this" {
  count  = var.attach_deny_insecure_transport_policy || var.attach_policy ? 1 : 0
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.combined[0].json
  depends_on = [
    aws_s3_bucket_public_access_block.this
  ]
}
#####################################################################################
# Replication Configuration for S3
#####################################################################################
resource "aws_s3_bucket_replication_configuration" "replication" {
  count      = var.enable_replication ? 1 : 0
  depends_on = [aws_s3_bucket_versioning.this[0]]
  role       = aws_iam_role.replication[0].arn
  bucket     = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = flatten(try([var.replication_configuration["rules"]], []))
    content {
      id       = try(rule.value.id, null)
      priority = try(rule.value.priority, null)
      status   = try(tobool(rule.value.status) ? "Enabled" : "Disabled", title(lower(rule.value.status)), "Enabled")

      dynamic "delete_marker_replication" {
        for_each = flatten(try([rule.value.delete_marker_replication_status], [rule.value.delete_marker_replication], []))
        content {
          status = try(tobool(delete_marker_replication.value) ? "Enabled" : "Disabled", title(lower(delete_marker_replication.value)))
        }
      }

      dynamic "existing_object_replication" {
        for_each = flatten(try([rule.value.existing_object_replication_status], [rule.value.existing_object_replication], []))
        content {
          status = try(tobool(existing_object_replication.value) ? "Enabled" : "Disabled", title(lower(existing_object_replication.value)))
        }
      }

      dynamic "destination" {
        for_each = try(flatten([rule.value.destination]), [])
        content {
          bucket        = aws_s3_bucket.replication-bucket[0].arn
          storage_class = try(destination.value.storage_class, null)
          account       = try(destination.value.account_id, destination.value.account, null)

          dynamic "access_control_translation" {
            for_each = try(flatten([destination.value.access_control_translation]), [])
            content {
              owner = title(lower(access_control_translation.value.owner))
            }
          }

          dynamic "encryption_configuration" {
            for_each = flatten([try(destination.value.encryption_configuration.replica_kms_key_id, destination.value.replica_kms_key_id, [])])
            content {
              replica_kms_key_id = encryption_configuration.value
            }
          }

          dynamic "replication_time" {
            for_each = try(flatten([destination.value.replication_time]), [])
            content {
              status = try(tobool(replication_time.value.status) ? "Enabled" : "Disabled", title(lower(replication_time.value.status)), "Disabled")

              dynamic "time" {
                for_each = try(flatten([replication_time.value.minutes]), [])
                content {
                  minutes = replication_time.value.minutes
                }
              }
            }
          }

          dynamic "metrics" {
            for_each = try(flatten([destination.value.metrics]), [])
            content {
              status = try(tobool(metrics.value.status) ? "Enabled" : "Disabled", title(lower(metrics.value.status)), "Disabled")

              dynamic "event_threshold" {
                for_each = try(flatten([metrics.value.minutes]), [])
                content {
                  minutes = metrics.value.minutes
                }
              }
            }
          }
        }
      }

      dynamic "source_selection_criteria" {
        for_each = try(flatten([rule.value.source_selection_criteria]), [])
        content {
          dynamic "replica_modifications" {
            for_each = flatten([try(source_selection_criteria.value.replica_modifications.enabled, source_selection_criteria.value.replica_modifications.status, [])])
            content {
              status = try(tobool(replica_modifications.value) ? "Enabled" : "Disabled", title(lower(replica_modifications.value)), "Disabled")
            }
          }

          dynamic "sse_kms_encrypted_objects" {
            for_each = flatten([try(source_selection_criteria.value.sse_kms_encrypted_objects.enabled, source_selection_criteria.value.sse_kms_encrypted_objects.status, [])])
            content {
              status = try(tobool(sse_kms_encrypted_objects.value) ? "Enabled" : "Disabled", title(lower(sse_kms_encrypted_objects.value)), "Disabled")
            }
          }
        }
      }

      dynamic "filter" {
        for_each = length(try(flatten([rule.value.filter]), [])) == 0 ? [true] : []
        content {
        }
      }

      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) == 1]
        content {
          prefix = try(filter.value.prefix, null)
          dynamic "tag" {
            for_each = try(filter.value.tags, filter.value.tag, [])
            content {
              key   = tag.key
              value = tag.value
            }
          }
        }
      }
      # Max 1 block - filter - with more than one key arguments or multiple tags
      dynamic "filter" {
        for_each = [for v in try(flatten([rule.value.filter]), []) : v if max(length(keys(v)), length(try(rule.value.filter.tags, rule.value.filter.tag, []))) > 1]
        content {
          and {
            prefix = try(filter.value.prefix, null)
            tags   = try(filter.value.tags, filter.value.tag, null)
          }
        }
      }
    }
  }
}