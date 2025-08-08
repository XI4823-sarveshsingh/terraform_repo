resource "aws_iam_role" "step_function_role" {
  name = var.iam_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "states.${var.aws_region}.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "step_function_policy" {
  name = "${var.iam_role_name}-policy"
  role = aws_iam_role.step_function_role.id

  policy = var.iam_policy_json
}

data "template_file" "state_machine_def" {
  template = file(var.definition_file)
}

resource "aws_sfn_state_machine" "this" {
  name       = var.name
  role_arn   = aws_iam_role.step_function_role.arn
  type       = var.type
  definition = var.definition

  tags       = var.tags
}
