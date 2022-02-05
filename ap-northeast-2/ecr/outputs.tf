output "ecr-repositories" {
  value = values(aws_ecr_repository.repo).*.arn
}
