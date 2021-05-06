module "lb_firewall" {
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name                = "alb-${local.name}"
  description         = "Security group for bastion"
  vpc_id              = data.terraform_remote_state.networking.outputs.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
  egress_rules        = ["all-all"]
}


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5"

  name                             = local.name
  load_balancer_type               = "application"
  vpc_id                           = data.terraform_remote_state.networking.outputs.vpc_id
  subnets                          = data.terraform_remote_state.networking.outputs.public_subnets
  tags                             = local.common_tags
  enable_cross_zone_load_balancing = true
  internal                         = false
  security_groups                  = [module.lb_firewall.security_group_id]

  http_tcp_listeners = [{
    port        = 80
    protocol    = "HTTP"
    action_type = "fixed-response"

    fixed_response = {
      content_type = "application/json"
      message_body = "{}"
      status_code  = "403"
    }
  }]
}
