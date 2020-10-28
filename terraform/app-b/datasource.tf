data "aws_region" "current" {
}
data "aws_subnet" "public_a" {
  tags = {
    "Name" = "tdc-recife-2020-fargate-demo-public-us-east-1a"
  }
}
data "aws_subnet" "public_b" {
  tags = {
    "Name" = "tdc-recife-2020-fargate-demo-public-us-east-1b"
  }
}
data "aws_subnet" "private_a" {
  tags = {
    "Name" = "tdc-recife-2020-fargate-demo-private-us-east-1a"
  }
}
data "aws_subnet" "private_b" {
  tags = {
    "Name" = "tdc-recife-2020-fargate-demo-private-us-east-1b"
  }
}
data "aws_ecs_cluster" "current" {
  cluster_name = var.cluster_name
}
data "aws_lb" "current" {
  name = var.lb_name
}
