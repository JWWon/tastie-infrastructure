locals {
  repositories = yamldecode(file("./repository.yaml")).ecr_repositories
}

resource "aws_ecr_repository" "repo" {
  for_each = {
    for repository in local.repositories :
    repository.name => repository
  }

  name                 = each.key
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
