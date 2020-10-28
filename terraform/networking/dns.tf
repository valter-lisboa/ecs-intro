resource "aws_route53_zone" "this" {
  name          = local.private_domain
  force_destroy = true

  vpc {
    vpc_id = module.vpc.vpc_id
  }

  tags = merge(
    local.common_tags,
    { Name = local.private_domain }
  )
}

resource "aws_vpc_dhcp_options" "this" {
  domain_name         = local.private_domain
  domain_name_servers = ["AmazonProvidedDNS"]

  tags = merge(
      local.common_tags,
      { Name = local.name }
  )
}

resource "aws_vpc_dhcp_options_association" "this" {
  vpc_id          = module.vpc.vpc_id
  dhcp_options_id = aws_vpc_dhcp_options.this.id
}

resource "aws_service_discovery_private_dns_namespace" "this" {
  name        = local.registry_domain
  description = "auto discovery for Fargate ECS services"
  vpc         = module.vpc.vpc_id
}
