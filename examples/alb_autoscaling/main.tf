locals {
  cluster_name = "example"
  vpc_id       = "vpc-xxxxxxxx"
  subnets = [
    "subnet-xxxxxxxxx",
    "subnet-xxxxxxxxx",
    "subnet-xxxxxxxxx"
  ]
  task_role_arn      = "arn:aws:iam::xxxxxxxxxxxx:role/TaskRole"
  execution_role_arn = "arn:aws:iam::xxxxxxxxxxxx:role/ecsTaskExecutionRole"

}

### security_groups
## service sg
resource "aws_security_group" "nginx" {
  name        = "ecs-${local.cluster_name}-nginx-sg"
  description = "nginx_service"
  vpc_id      = local.vpc_id
}
## alb sg
resource "aws_security_group" "alb" {
  name        = "alb-${local.cluster_name}-sg"
  description = "alb-${local.cluster_name}-sg"
  vpc_id      = local.vpc_id
}

### security_groups rules
## service to internet
resource "aws_vpc_security_group_egress_rule" "nginx" {
  description       = "internet"
  security_group_id = aws_security_group.nginx.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
## service from alb
resource "aws_vpc_security_group_ingress_rule" "nginx" {
  description                  = "alb"
  security_group_id            = aws_security_group.nginx.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = "80"
  to_port                      = "80"
  ip_protocol                  = "tcp"
}
## alb from internet
resource "aws_vpc_security_group_ingress_rule" "alb" {
  description       = "internet"
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
## alb to service
resource "aws_vpc_security_group_egress_rule" "alb" {
  description                  = "alb"
  security_group_id            = aws_security_group.alb.id
  referenced_security_group_id = aws_security_group.nginx.id
  from_port                    = "80"
  to_port                      = "80"
  ip_protocol                  = "tcp"
}

### ALB
## alb
resource "aws_alb" "this" {
  name               = local.cluster_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = local.subnets
}
## alb target group
resource "aws_lb_target_group" "nginx" {
  name        = "${local.cluster_name}-nginx"
  port        = "80"
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "ip"

}
## alb listener
resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_alb.this.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx.arn
  }
}

### ecs cluster and service
module "ecs_fargate" {
  source       = "my-devops-way/terraform-aws-ecs-fargate-services/aws"
  cluster_name = local.cluster_name
  services = [
    {
      name                 = "nginx"
      desired_count        = 1
      force_new_deployment = true

      network_configuration = {
        assign_public_ip = true # this is true when subnets are "public"
        subnets          = local.subnets
        security_groups  = [aws_security_group.nginx.id]
      }

      task_definition = { #task definition
        family                = "nginx"
        container_definitions = file("./container_definitions_nginx.json")
        task_role_arn         = local.task_role_arn
        execution_role_arn    = local.execution_role_arn
        memory                = "1024"
        cpu                   = "512"
        ephemeral_storage     = 21
      }

      load_balancer = [
        {
          target_group_arn = aws_lb_target_group.nginx.arn
          container_name   = "nginx"
          container_port   = "80"
        }
      ]
    }
  ]

}

### autoscaling
## target
resource "aws_appautoscaling_target" "nginx" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${local.cluster_name}/${module.ecs_fargate.service_name[0]}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
## cpu policy
resource "aws_appautoscaling_policy" "cpu" {
  name               = "${local.cluster_name}-nginx-service-cpu-autoscaling-policy"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.nginx.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}
