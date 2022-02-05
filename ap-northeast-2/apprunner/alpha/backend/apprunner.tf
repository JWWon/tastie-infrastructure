locals {
  parametersPrefix = "/apprunner/alpha/backend/"
  backendImageTag = trimspace(file("./version.txt"))
}

data "aws_ssm_parameters_by_path" "parameters" {
  path = local.parametersPrefix
}

resource "aws_apprunner_service" "backend" {
  service_name = "alpha-backend"

  instance_configuration {
    cpu    = 1024
    memory = 2048
  }

  source_configuration {
    authentication_configuration {
      access_role_arn = "arn:aws:iam::645216642656:role/service-role/AppRunnerECRAccessRole"
    }

    auto_deployments_enabled = false
    image_repository {
      image_configuration {
        port = "3000"
        runtime_environment_variables = {
          for idx, param in data.aws_ssm_parameters_by_path.parameters.names:
            trimprefix(param, local.parametersPrefix) => sensitive(data.aws_ssm_parameters_by_path.parameters.values[idx])
        }
      }
      image_identifier      = "645216642656.dkr.ecr.ap-northeast-1.amazonaws.com/tastie/backend:${local.backendImageTag}"
      image_repository_type = "ECR"
    }
  }
}

output "apprunner_backend_url" {                            
  value = aws_apprunner_service.backend.service_url                        
}
