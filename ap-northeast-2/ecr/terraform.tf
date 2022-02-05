terraform {
  required_version = "1.1.5"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "tastie"

    workspaces {
      name = "aws-apne2-ecr"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.70.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}
