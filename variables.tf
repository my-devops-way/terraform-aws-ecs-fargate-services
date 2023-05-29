variable "cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}
variable "services" {
  description = "Provides an ECS service - effectively a task that is expected to run until an error occurs or a user terminates it (typically a webserver or a database)."
  type = list(object({
    name                              = string
    desired_count                     = number
    force_new_deployment              = optional(bool, false)
    health_check_grace_period_seconds = optional(number)
    network_configuration = object({
      assign_public_ip = bool
      subnets          = list(string)
      security_groups  = list(string)
    })
    load_balancer = optional(list(object({
      target_group_arn = string
      container_name   = string
      container_port   = string
    })), [])
    enable_execute_command = optional(bool, false)
    capacity_provider_strategy = optional(list(object({
      capacity_provider = string
      weight            = string
      base              = optional(string)
    })), [])
    task_definition = object({
      family                = string
      container_definitions = string
      task_role_arn         = optional(string)
      execution_role_arn    = optional(string)
      memory                = string
      cpu                   = string
      ephemeral_storage     = optional(string)
      efs_volumes = optional(list(object({
        name = string
        efs_volume_configuration = object({
          file_system_id     = string
          root_directory     = optional(string)
          transit_encryption = optional(string)
        })
        })
      ), [])
      bind_mount_volumes = optional(list(object({
        name = string
      })), [])
    })
  }))
}
variable "containerInsights" {
  description = "(Optional) enable CloudWatch Container Insights for a cluster"
  type        = string
  default     = "enabled"
  validation {
    condition     = var.containerInsights == "enabled" || var.containerInsights == "disabled"
    error_message = "The containerInsights value must be \"enabled\" or \"disabled\""
  }
}
