output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "cloudmap_namespace_id" {
  value = aws_service_discovery_private_dns_namespace.this.id
}

output "cloudmap_namespace_arn" {
  value = aws_service_discovery_private_dns_namespace.this.arn
}
