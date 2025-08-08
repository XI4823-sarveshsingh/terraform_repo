# provider "aws" {
#   region = var.region
#   default_tags {
#     tags = var.common_tags
#   }
#   assume_role {
#     role_arn = var.assume_role_arn
#   }
# }

##############################################################################################################
# Private Repository
##############################################################################################################

data "template_file" "policy_document" {
  count    = var.permissions_policy_path != "" ? 1 : 0
  template = file("${path.root}//${var.permissions_policy_path}")
  vars     = var.permissions_policy_vars
}
resource "aws_ecr_repository" "this" {
  count                = var.type == "private" ? 1 : 0
  name                 = var.name
  image_tag_mutability = var.image_tag_mutability
  force_delete         = var.enable_force_delete
  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.kms_key_id
  }
  image_scanning_configuration {
    scan_on_push = var.enable_image_scan_on_push
  }
}
resource "aws_ecr_repository_policy" "this" {
  count      = var.type == "private" && var.permissions_policy_path != "" ? 1 : 0
  repository = aws_ecr_repository.this[0].name
  policy     = data.template_file.policy_document[0].rendered
}
resource "aws_ecr_lifecycle_policy" "this" {
  count      = var.type == "private" && var.lifecycle_policy_path != "" ? 1 : 0
  repository = aws_ecr_repository.this[0].name
  policy     = file("${path.root}//${var.lifecycle_policy_path}")
}

##############################################################################################################
# Public Repository
##############################################################################################################

resource "aws_ecrpublic_repository" "this" {
  count           = var.type == "public" ? 1 : 0
  repository_name = var.name
  dynamic "catalog_data" {
    for_each = try(var.catalog_data, {}) == {} ? [] : [var.catalog_data]
    content {
      about_text        = try(catalog_data.value.about_text, "")
      architectures     = try(catalog_data.value.architectures, "")
      description       = try(catalog_data.value.description, "")
      logo_image_blob   = try(catalog_data.value.logo_image_blob, "")
      operating_systems = try(catalog_data.value.operating_systems, "")
      usage_text        = try(catalog_data.value.usage_text, "")
    }
  }
}
resource "aws_ecrpublic_repository_policy" "example" {
  count           = var.type == "public" && var.permissions_policy_path != "" ? 1 : 0
  repository_name = aws_ecrpublic_repository.this[0].repository_name
  policy          = data.template_file.policy_document[0].rendered
}

###################################################################################################################
# Registry Configuration
###################################################################################################################

data "template_file" "registry_policy_document" {
  count    = var.registry_policy_path != "" ? 1 : 0
  template = file("${path.root}//${var.registry_policy_path}")
  vars     = var.registry_policy_vars
}
resource "aws_ecr_registry_policy" "this" {
  count  = var.registry_policy_path != "" ? 1 : 0
  policy = data.template_file.registry_policy_document[0].rendered
}
resource "aws_ecr_pull_through_cache_rule" "this" {
  for_each              = { for k, v in var.pull_through_cache_rules : k => v }
  ecr_repository_prefix = each.value.ecr_repository_prefix
  upstream_registry_url = each.value.upstream_registry_url
}
resource "aws_ecr_registry_scanning_configuration" "this" {
  count     = var.manage_registry_scanning_config ? 1 : 0
  scan_type = var.registry_scan_type
  dynamic "rule" {
    for_each = var.registry_scan_rules
    content {
      scan_frequency = rule.value.scan_frequency
      repository_filter {
        filter      = rule.value.filter
        filter_type = try(rule.value.filter_type, "WILDCARD")
      }
    }
  }
}
resource "aws_ecr_replication_configuration" "this" {
  count = var.create_registry_replication_configuration ? 1 : 0
  replication_configuration {
    dynamic "rule" {
      for_each = var.registry_replication_rules
      content {
        dynamic "destination" {
          for_each = rule.value.destinations
          content {
            region      = destination.value.region
            registry_id = destination.value.registry_id
          }
        }
        dynamic "repository_filter" {
          for_each = try(rule.value.repository_filters, [])
          content {
            filter      = repository_filter.value.filter
            filter_type = repository_filter.value.filter_type
          }
        }
      }
    }
  }
}