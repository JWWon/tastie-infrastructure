# resource "aws_iam_policy" "apprunner" {
#   name   = "alpha-kr-apprunner-base"
#   policy = file("policies/apprunner.json")
# }

# resource "aws_iam_role" "backend" {
#   name = "alpha-kr-apprunner-backend"

#   managed_policy_arns = [aws_iam_policy.apprunner.arn]
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Principal = {
#           Service = "ec2.amazonaws.com"
#         }
#       },
#     ]
#   })
# }
