variable "cluster_name" {
  type        = string
  description = "(Optional) - The name of the cluster if the cluster does not exist"
}
variable "services" {
  type = list(object({
    name                 = string
    desired_count        = string
    force_new_deployment = bool
    network_configuration = object({
      assign_public_ip = bool
      subnets          = list(string)
      security_groups  = list(string)
    })
    task_definition = object({
      family                = string
      container_definitions = any
      task_role_arn         = string
      execution_role_arn    = string
      memory                = string
      cpu                   = string
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
    load_balancer = optional(list(object({
      target_group_arn = string
      container_name   = string
      container_port   = string
    })), [])
    enable_execute_command     = string
    capacity_provider_strategy = list(any)
  }))
}
variable "containerInsights" {
  type    = string
  default = "enabled"
}
