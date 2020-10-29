data "aws_region" "current" {
}
data "aws_subnet" "private_a" {
  id = var.subnet_private_ids[0]
}
data "aws_subnet" "private_b" {
  id = var.subnet_private_ids[1]
}
data "aws_ecs_cluster" "current" {
  cluster_name = var.cluster_name
}
