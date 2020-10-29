terraform {
  required_version = "~> 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3"
    }

    random = {
      source = "hashicorp/random"
    }
  }
}

module "codebuild" {
  source = "../../modules/codepipeline"

  project_name                 = "app-a"
  env                          = "dev"
  codecommit_repository_name   = "app-a"
  codecommit_repository_branch = "master"
}
