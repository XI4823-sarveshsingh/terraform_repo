region                 = "ap-south-1"
function_name          = "xebia-cloud-coe"
runtime                = "python3.12"
package_type           = "Zip"
filename               = "lambda_code.zip"
execution_role_arn     = "arn:aws:iam::123456789012:role/lambda-execution-role"
kms_key_arn            = "arn:aws:kms:ap-south-1:123456789012:key/1a2bc3d4-a1b2-12a3-123a-12abc3456789"
log_retention_in_days  = 365
log_encryption_key_arn = "arn:aws:kms:ap-south-1:123456789012:key/1a2bc3d4-a1b2-12a3-123a-12abc3456789"
vpc_config = {
  security_group_ids = ["sg-1a23bc45de678f9g0"],
  subnet_ids         = ["subnet-01a23456bc78de901", "subnet-ab0cdefg12hi345"]
}