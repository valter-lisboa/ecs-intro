locals {
  vpc_cidr        = "172.16.0.0/16"
  name            = "tdc-recife-2020-fargate-demo"
  bastion         = "bastion-${local.name}"
  private_domain  = "tdc2020.fargate.cloud"
  registry_domain = "discovery.${local.private_domain}"

  common_tags = {
    Environment = "test"
  }
}
