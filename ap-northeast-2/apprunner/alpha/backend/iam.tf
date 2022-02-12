resource "aws_iam_policy" "apprunner" {
  name   = "alpha-kr-apprunner-base"
  policy = file("policies/apprunner.json")
}

resource "aws_iam_role" "backend" {
  name = "alpha-kr-apprunner-backend"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "build.apprunner.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backend" {
  role       = aws_iam_role.backend.name
  policy_arn = aws_iam_policy.apprunner.arn
}
