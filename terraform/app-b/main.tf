data "terraform_remote_state" "networking" {
  backend = "local"

  config = {
    path = "../networking/terraform.tfstate"
  }
}

data "terraform_remote_state" "cluster" {
  backend = "local"

  config = {
    path = "../cluster/terraform.tfstate"
  }
}

data "aws_caller_identity" "current" {
}

module "ecs" {
  source = "../../modules/ecs"

  cluster_name = data.terraform_remote_state.cluster.outputs.ecs_cluster.name
  app_name     = "app-b"
  app_image    = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/app-b"
  environment  = "development"

  subnet_private_ids    = data.terraform_remote_state.networking.outputs.private_subnets
  cloudmap_namespace_id = data.terraform_remote_state.networking.outputs.cloudmap_namespace_id
}
