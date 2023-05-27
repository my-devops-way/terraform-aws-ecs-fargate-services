# #####################
# ecs cluster resources
# #####################

resource "aws_ecs_cluster" "this" {
  name = var.cluster_name
  setting {
    name  = "containerInsights"
    value = var.containerInsights
  }

}
resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name       = aws_ecs_cluster.this.name
  capacity_providers = ["FARGATE", "FARGATE_SPOT"]
}
# ##############################
# ecs task definitions resources
# ##############################

data "aws_ecs_task_definition" "this" {
  count           = length(var.services)
  task_definition = aws_ecs_task_definition.this[count.index].family
}
resource "aws_ecs_task_definition" "this" {
  count                    = length(var.services)
  family                   = var.services[count.index].task_definition.family
  container_definitions    = var.services[count.index].task_definition.container_definitions
  task_role_arn            = var.services[count.index].task_definition.task_role_arn
  execution_role_arn       = var.services[count.index].task_definition.execution_role_arn
  requires_compatibilities = ["FARGATE"]
  memory                   = var.services[count.index].task_definition.memory
  cpu                      = var.services[count.index].task_definition.cpu
  network_mode             = "awsvpc"
  dynamic "volume" {
    for_each = var.services[count.index].task_definition.efs_volumes
    content {
      name = volume.value["name"]
      efs_volume_configuration {
        file_system_id     = volume.value["efs_volume_configuration"].file_system_id
        root_directory     = volume.value["efs_volume_configuration"].root_directory
        transit_encryption = volume.value["efs_volume_configuration"].transit_encryption
      }

    }
  }
  dynamic "volume" {
    for_each = var.services[count.index].task_definition.bind_mount_volumes
    content {
      name = volume.value["name"]
    }
  }
}

# ######################
# ecs services resources
# ######################
resource "aws_ecs_service" "this" {
  count                = length(var.services)
  name                 = var.services[count.index].name
  cluster              = aws_ecs_cluster.this.arn
  desired_count        = var.services[count.index].desired_count
  force_new_deployment = var.services[count.index].force_new_deployment
  network_configuration {
    assign_public_ip = var.services[count.index].network_configuration.assign_public_ip
    subnets          = var.services[count.index].network_configuration.subnets
    security_groups  = var.services[count.index].network_configuration.security_groups
  }
  task_definition        = "${aws_ecs_task_definition.this[count.index].family}:${max(aws_ecs_task_definition.this[count.index].revision, data.aws_ecs_task_definition.this[count.index].revision)}"
  enable_execute_command = var.services[count.index].enable_execute_command
  dynamic "load_balancer" {
    for_each = var.services[count.index].load_balancer
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.value.container_name
      container_port   = load_balancer.value.container_port
    }
  }

  dynamic "capacity_provider_strategy" {
    for_each = var.services[count.index].capacity_provider_strategy
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = lookup(capacity_provider_strategy.value, "base", null)
    }
  }

}
