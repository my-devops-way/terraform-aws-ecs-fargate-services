<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.5 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_ecs_service.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecs_task_definition) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | (Optional) - The name of the cluster if the cluster does not exist | `string` | n/a | yes |
| <a name="input_containerInsights"></a> [containerInsights](#input\_containerInsights) | n/a | `string` | `"enabled"` | no |
| <a name="input_services"></a> [services](#input\_services) | n/a | <pre>list(object({<br>    name                              = string<br>    desired_count                     = number<br>    force_new_deployment              = optional(bool, false)<br>    health_check_grace_period_seconds = optional(number)<br>    network_configuration = object({<br>      assign_public_ip = bool<br>      subnets          = list(string)<br>      security_groups  = list(string)<br>    })<br>    load_balancer = optional(list(object({<br>      target_group_arn = string<br>      container_name   = string<br>      container_port   = string<br>    })), [])<br>    enable_execute_command = optional(bool, false)<br>    capacity_provider_strategy = optional(list(object({<br>      capacity_provider = string<br>      weight            = string<br>      base              = optional(string)<br>    })), [])<br>    task_definition = object({<br>      family                = string<br>      container_definitions = string<br>      task_role_arn         = optional(string)<br>      execution_role_arn    = optional(string)<br>      memory                = string<br>      cpu                   = string<br>      ephemeral_storage     = optional(string)<br>      efs_volumes = optional(list(object({<br>        name = string<br>        efs_volume_configuration = object({<br>          file_system_id     = string<br>          root_directory     = optional(string)<br>          transit_encryption = optional(string)<br>        })<br>        })<br>      ), [])<br>      bind_mount_volumes = optional(list(object({<br>        name = string<br>      })), [])<br>    })<br>  }))</pre> | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
