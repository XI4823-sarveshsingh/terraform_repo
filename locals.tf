locals {
    vpc_configuration = {
        subnet_ids = data.aws_subnets.subnets_for_eks.ids
        security_group_ids = [module.lambda_security_group.security_group_id]
    }
}


# # locals {
# #   step_function_definition = templatefile("${path.module}/state-machine-definition.tpl.json", {
# #     lambda1_arn = module.lambda_functions["lambda1"].lambda_arn,
# #     lambda2_arn = module.lambda_functions["lambda2"].lambda_arn
# #   })
# # }
# locals {
#   stepfunctions = [
#     {
#       name             = "sf-first"
#       iam_role_name    = "sf-role-first"
#       iam_policy_json  = file("${path.module}/policies/sf1_policy.json")
#       definition_file  = "${path.module}/statemachines/sf1.json"
#       lambda_arn        = var.lambda_arn_list[0]
#     },
#     {
#       name             = "sf-second"
#       iam_role_name    = "sf-role-second"
#       iam_policy_json  = file("${path.module}/policies/sf2_policy.json")
#       definition_file  = "${path.module}/statemachines/sf2.json"
#       lambda_arn        = var.lambda_arn_list[0]
#     },
#     {
#       name             = "sf-third"
#       iam_role_name    = "sf-role-third"
#       iam_policy_json  = file("${path.module}/policies/sf3_policy.json")
#       definition_file  = "${path.module}/statemachines/sf3.json"
#       lambda_arn        = var.lambda_arn_list[0]
#     }
#   ]
# }