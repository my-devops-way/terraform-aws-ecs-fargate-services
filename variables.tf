variable "cluster_name" {
  type        = string
  description = "(Optional) - The name of the cluster if the cluster does not exist"
}
variable "services" {
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
  type    = string
  default = "enabled"
}
