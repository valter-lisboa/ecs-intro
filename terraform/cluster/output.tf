output "ecs_cluster" {
  value = aws_ecs_cluster.this
}

output "alb_id" {
  value = module.alb.this_lb_id
}

output "alb_arn" {
  value = module.alb.this_lb_arn
}

output "listener_id" {
  value = module.alb.http_tcp_listener_ids[0]
}

output "listener_arn" {
  value = module.alb.http_tcp_listener_arns[0]
}
