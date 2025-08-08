resource "aws_iam_role" "lambda_execution_role" {
  name = var.role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name        = var.policy_name
  description = "Allows Lambda to access CloudWatch Logs, Bedrock S3, and pull images from ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      # CloudWatch Logs permissions for Lambda
      {
        Action   = "logs:CreateLogGroup"
        Effect   = "Allow"
        Resource = "arn:aws:logs:us-east-1:*:*"
      },
      {
        Action   = "logs:CreateLogStream"
        Effect   = "Allow"
        Resource = "arn:aws:logs:us-east-1:*:log-group:/aws/lambda/*:log-stream:*"
      },
      {
        Action   = "logs:PutLogEvents"
        Effect   = "Allow"
        Resource = "arn:aws:logs:us-east-1:*:log-group:/aws/lambda/*:log-stream:*"
      },

      # S3 permissions for accessing the bucket
      {
        Action   = [
                "s3:*",
                "s3-object-lambda:*"
            ]
        Effect   = "Allow"
        Resource = "*"//module.backend_bucket.s3_bucket_arn
      },

      # ECR permissions for pulling Docker images
      {
        Action   = "ecr:GetAuthorizationToken"
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = "ecr:BatchGetImage"
        Effect   = "Allow"
        Resource = "*"
        # Resource = data.terraform_remote_state.shared_state.outputs.private_repository_arn
      },
      {
        Action   = "ecr:BatchCheckLayerAvailability"
        Effect   = "Allow"
        Resource = "*"
        # Resource = data.terraform_remote_state.shared_state.outputs.private_repository_arn
      },
      {
        Action   = [
        "ec2:CreateNetworkInterface",
        "ec2:DescribeNetworkInterfaces",
        "ec2:DeleteNetworkInterface"
        ]
        Effect   = "Allow"
        Resource = "*"
        # Resource = data.terraform_remote_state.shared_state.outputs.private_repository_arn
      },
      {
        Action   = ["secretsmanager:GetSecretValue"]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_execution_policy_attachment" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  
}