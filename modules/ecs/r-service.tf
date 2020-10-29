# Target group / Listener rule
resource "aws_lb_target_group" "this" {
  count = var.lb_listener_arn != null ? 1 : 0

  name                 = "${var.app_name}-lb-tg"
  port                 = 8080
  protocol             = "HTTP"
  vpc_id               = data.aws_subnet.private_a.vpc_id
  target_type          = "ip"
  deregistration_delay = 10

  health_check {
    enabled = true
    path    = "/healthcheck"
    matcher = "200-299"
  }
}
resource "aws_lb_listener_rule" "all" {
  count = var.lb_listener_arn != null ? 1 : 0

  listener_arn = var.lb_listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[0].arn
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

# Security Group
resource "aws_security_group" "ecs_service" {
  name        = "${var.app_name}-ecs-service-sg"
  description = "Allow traffic from ${var.app_name} ALB"
  vpc_id      = data.aws_subnet.private_a.vpc_id

  ingress {
    description = "HTTP"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # HACK
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name" = "${var.app_name}-ecs-service-sg"
  }
}

# Service
resource "aws_ecs_service" "this" {
  name          = var.app_name
  cluster       = var.cluster_name
  launch_type   = "FARGATE"
  desired_count = 1

  task_definition = aws_ecs_task_definition.this.arn
  # iam_role        = aws_iam_role.foo.arn

  network_configuration {
    subnets = [
      data.aws_subnet.private_a.id,
      data.aws_subnet.private_b.id
    ]
    security_groups = [aws_security_group.ecs_service.id]
  }

  dynamic "load_balancer" {
    for_each = var.lb_listener_arn != null ? [aws_lb_target_group.this[0].arn] : []

    content {
      target_group_arn = load_balancer.value
      container_name   = var.app_name
      container_port   = 8080
    }
  }

  service_registries {
    registry_arn   = aws_service_discovery_service.this.arn
    container_port = 0
    port           = 0
  }

  depends_on = [
    aws_lb_target_group.this
  ]
}

# Task Definition
resource "aws_ecs_task_definition" "this" {
  family = var.app_name

  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.task_execution_role.arn

  memory                   = 512
  cpu                      = 256
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  container_definitions = jsonencode(
    [
      {
        "name"  = var.app_name
        "image" = var.app_image,
        "portMappings" = [
          {
            "hostPort"      = 8080,
            "protocol"      = "tcp",
            "containerPort" = 8080
          }
        ],
        "cpu"         = 10,
        "memory"      = 128,
        "environment" = [],
        "mountPoints" = [],
        "volumesFrom" = [],
        "essential"   = true,

        # WIP disabled
        "logConfiguration" = {
          logDriver = "awslogs"
          "options" = {
            "awslogs-group"         = "/ecs/${var.app_name}"
            "awslogs-region"        = data.aws_region.current.name
            "awslogs-stream-prefix" = "helloworld"
          }
        }
      }
    ]
  )

  # tags = {
  #   Environment = "production"
  # }
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/ecs/${var.app_name}"
  retention_in_days = 90

  # kms_key_id = var.kms_key_id

  tags = {
    "Name"        = "${var.app_name}-${var.environment}"
    "Environment" = var.environment
    "Automation"  = "Terraform"
  }
}

# #
# # IAM - instance (optional)
# #
# data "aws_iam_policy_document" "instance_role_policy_doc" {
#   statement {
#     actions = [
#       "ecs:DeregisterContainerInstance",
#       "ecs:RegisterContainerInstance",
#       "ecs:Submit*",
#     ]

#     resources = [data.aws_ecs_cluster.current.arn]
#   }

#   statement {
#     actions = [
#       "ecs:UpdateContainerInstancesState",
#     ]

#     resources = ["*"]

#     condition {
#       test     = "StringEquals"
#       variable = "ecs:cluster"
#       values   = [data.aws_ecs_cluster.current.arn]
#     }
#   }

#   statement {
#     actions = [
#       "ecs:DiscoverPollEndpoint",
#       "ecs:Poll",
#       "ecs:StartTelemetrySession",
#     ]

#     resources = ["*"]
#   }

#   statement {
#     actions = [
#       "logs:CreateLogStream",
#       "logs:PutLogEvents",
#     ]

#     resources = [aws_cloudwatch_log_group.main.arn]
#   }

#   statement {
#     actions = [
#       "ecr:GetAuthorizationToken",
#     ]

#     resources = ["*"]
#   }

#   statement {
#     actions = [
#       "ecr:BatchCheckLayerAvailability",
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:BatchGetImage",
#     ]

#     resources = ["*"]
#   }
# }

#
# IAM - task
#
data "aws_iam_policy_document" "ecs_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "task_execution_role_policy_doc" {
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["${aws_cloudwatch_log_group.main.arn}:*"]
  }

  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }

  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "task_role" {
  name               = "ecs-task-role-${var.app_name}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

resource "aws_iam_role" "task_execution_role" {
  name               = "ecs-task-execution-role-${var.app_name}-${var.environment}"
  assume_role_policy = data.aws_iam_policy_document.ecs_assume_role_policy.json
}

resource "aws_iam_role_policy" "task_execution_role_policy" {
  name   = "${aws_iam_role.task_execution_role.name}-policy"
  role   = aws_iam_role.task_execution_role.name
  policy = data.aws_iam_policy_document.task_execution_role_policy_doc.json
}

resource "aws_service_discovery_service" "this" {
  name = var.app_name

  dns_config {
    namespace_id = var.cloudmap_namespace_id

    dns_records {
      ttl  = 10
      type = "A"
    }

    routing_policy = "MULTIVALUE"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
