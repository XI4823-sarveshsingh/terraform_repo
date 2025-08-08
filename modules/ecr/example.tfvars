name                      = "sample-service"
type                      = "private"
enable_image_scan_on_push = true
encryption_type           = "KMS"
kms_key_id                = "arn:aws:kms:ap-south-1:111122223333:key/0987dcba-09fe-87dc-65ba-ab0987654321"
lifecycle_policy_path     = "policies/lifecycle-policy.json"
permissions_policy_path   = "policies/permissions-policy.json"
permissions_policy_vars = {
  account_id = "111122223333"
}

# Public Repo
# region should be us-east-1 only
# region = "us-east-1"
# type   = "public"
# catalog_data = {
#   about_text        = "Demo public repo for keeping demo images"
#   architectures     = ["ARM"]
#   description       = "Demo public repo"
#   operating_systems = ["Linux"]
#   usage_text        = "Should be used to setup demo"
# }

# Registry level configuration
# pull_through_cache_rules = [{
#   ecr_repository_prefix = "ecr-private"
#   upstream_registry_url = "private.ecr.aws"
#   },
# ]
# manage_registry_scanning_config = true
# registry_scan_type              = "ENHANCED"
# registry_scan_rules = [
#   {
#     scan_frequency = "SCAN_ON_PUSH"
#     filter         = "*"
#     filter_type    = "WILDCARD"
#     }, {
#     scan_frequency = "CONTINUOUS_SCAN"
#     filter         = "example"
#     filter_type    = "WILDCARD"
#   }
# ]
# create_registry_replication_configuration = true
# registry_replication_rules = [
#   {
#     destinations = [{
#       region      = "us-west-2"
#       registry_id = "474532148129"
#       }, {
#       region      = "eu-west-1"
#       registry_id = "474532148129"
#     }]

#     repository_filters = [{
#       filter      = "prod-microservice"
#       filter_type = "PREFIX_MATCH"
#     }]
#   }
# ]