module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 2"

  name                   = local.name
  tags                   = local.common_tags
  azs                    = ["us-east-1a", "us-east-1b"]
  cidr                   = local.vpc_cidr
  enable_dns_hostnames   = true
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  public_subnets         = ["172.16.0.0/24", "172.16.1.0/24"]
  private_subnets        = ["172.16.2.0/24", "172.16.3.0/24"]
}
