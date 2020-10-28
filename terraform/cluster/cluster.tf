resource "aws_ecs_cluster" "this" {
  name               = local.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(
    local.common_tags,
    { Name = local.name }
  )
}
