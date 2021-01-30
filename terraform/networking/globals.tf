locals {
  vpc_cidr        = "172.16.0.0/16"
  name            = "ecs-fargate-demo"
  bastion         = "bastion-${local.name}"
  private_domain  = "ecs-fargate-demo.cloud"
  registry_domain = "discovery.${local.private_domain}"

  common_tags = {
    Environment = "test"
  }
}
