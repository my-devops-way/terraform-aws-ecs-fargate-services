# AWS ECS Cluster Fargate multi Service Terraform Module ( front, back, apis ...)

This module create a basic cluster configuration for deploy common Docker apps (frontend, backend, apis).
![aws_fargate_ecs](https://github.com/my-devops-way/CICD/blob/main/svg/infrastructure/ecs_fargate_bakend_frontend.svg)
<!-- BEGIN_TF_DOCS -->


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.7 |
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

| Name | Description | Type |
|------|-------------|------|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the ECS cluster | `string` |
| <a name="input_containerInsights"></a> [containerInsights](#input\_containerInsights) | (Optional) enable CloudWatch Container Insights for a cluster | `string` |
| <a name="input_services"></a> [services](#input\_services) | Provides an ECS service - effectively a task that is expected to run until an error occurs or a user terminates it (typically a webserver or a database). | <pre>list(object({<br>    name                              = string<br>    desired_count                     = number<br>    force_new_deployment              = optional(bool, false)<br>    health_check_grace_period_seconds = optional(number)<br>    network_configuration = object({<br>      assign_public_ip = bool<br>      subnets          = list(string)<br>      security_groups  = list(string)<br>    })<br>    load_balancer = optional(list(object({<br>      target_group_arn = string<br>      container_name   = string<br>      container_port   = string<br>    })), [])<br>    enable_execute_command = optional(bool, false)<br>    capacity_provider_strategy = optional(list(object({<br>      capacity_provider = string<br>      weight            = string<br>      base              = optional(string)<br>    })), [])<br>    task_definition = object({<br>      family                = string<br>      container_definitions = string<br>      task_role_arn         = optional(string)<br>      execution_role_arn    = optional(string)<br>      memory                = string<br>      cpu                   = string<br>      ephemeral_storage     = optional(string)<br>      efs_volumes = optional(list(object({<br>        name = string<br>        efs_volume_configuration = object({<br>          file_system_id     = string<br>          root_directory     = optional(string)<br>          transit_encryption = optional(string)<br>        })<br>        })<br>      ), [])<br>      bind_mount_volumes = optional(list(object({<br>        name = string<br>      })), [])<br>    })<br>  }))</pre> |
#### Service item

| Property | Description | Type |
|----------|-------------|------|
| <a name="input_capacity_provider_strategy"></a> [capacity\_provider\_strategy](#input\_capacity\_provider\_strategy) | (Optional) Capacity provider strategies to use for the service. Can be one or more. These can be updated without destroying and recreating the service only if force\_new\_deployment = true and not changing from 0 capacity\_provider\_strategy blocks to greater than 0, or vice versa. See below. | <pre>optional(list(object({<br>    capacity_provider = string<br>    weight            = string<br>    base              = optional(string)<br>  })), [])</pre> |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | (Optional) Number of instances of the task definition to place and keep running. Defaults to 0. | `number` |
| <a name="input_enable_execute_command"></a> [enable\_execute\_command](#input\_enable\_execute\_command) | (Optional) Specifies whether to enable Amazon ECS Exec for the tasks within the service. | `optional(bool, false)` |
| <a name="input_force_new_deployment"></a> [force\_new\_deployment](#input\_force\_new\_deployment) | (Optional) Enable to force a new task deployment of the service. This can be used to update tasks to use a newer Docker image with same image/tag combination (e.g., myimage:latest), roll Fargate tasks onto a newer platform version, or immediately deploy ordered\_placement\_strategy and placement\_constraints updates. | `optional(bool, false)` |
| <a name="input_health_check_grace_period_seconds"></a> [health\_check\_grace\_period\_seconds](#input\_health\_check\_grace\_period\_seconds) | (Optional) Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers. | `optional(number)` |
| <a name="input_load_balancer"></a> [load\_balancer](#input\_load\_balancer) | (Optional) Configuration block for load balancers. | <pre>optional(list(object({<br>    target_group_arn = string<br>    container_name   = string<br>    container_port   = string<br>  })), [])</pre> |
| <a name="input_name"></a> [name](#input\_name) | (Required) Name of the service (up to 255 letters, numbers, hyphens, and underscores). | `string` |
| <a name="input_network_configuration"></a> [network\_configuration](#input\_network\_configuration) | (Optional) Network configuration for the service. This parameter is required for task definitions that use the awsvpc network mode to receive their own Elastic Network Interface, and it is not supported for other network modes. See below. | <pre>object({<br>    assign_public_ip = bool<br>    subnets          = list(string)<br>    security_groups  = list(string)<br>  })</pre> |
| <a name="input_task_definition"></a> [task\_definition](#input\_task\_definition) | Manages a revision of an ECS task definition to be used in aws\_ecs\_service. | <pre>object({<br>    family                = string<br>    container_definitions = string<br>    task_role_arn         = optional(string)<br>    execution_role_arn    = optional(string)<br>    memory                = string<br>    cpu                   = string<br>    ephemeral_storage     = optional(string)<br>    efs_volumes = optional(list(object({<br>      name = string<br>      efs_volume_configuration = object({<br>        file_system_id     = string<br>        root_directory     = optional(string)<br>        transit_encryption = optional(string)<br>      })<br>      })<br>    ), [])<br>    bind_mount_volumes = optional(list(object({<br>      name = string<br>    })), [])<br>  })</pre> |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | ARN that identifies the cluster. |
| <a name="output_service_id"></a> [service\_id](#output\_service\_id) | (List) ARNs that identifies the services. |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | (List) Names of the services. |
| <a name="output_task_definition_arn"></a> [task\_definition\_arn](#output\_task\_definition\_arn) | (List) Full ARN of the Task Definition (including both family and revision). |
| <a name="output_task_definition_arn_without_revision"></a> [task\_definition\_arn\_without\_revision](#output\_task\_definition\_arn\_without\_revision) | (List) ARNs of the Task Definitions with the trailing revision removed. This may be useful for situations where the latest task definition is always desired. If a revision isn't specified, the latest ACTIVE revision is used. See the AWS documentation for details. |
| <a name="output_task_definition_revision"></a> [task\_definition\_revision](#output\_task\_definition\_revision) | (List) Revisions of the tasks in a particular family. |

<!-- END_TF_DOCS -->
