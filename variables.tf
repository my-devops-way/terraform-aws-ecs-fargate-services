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
      efs_volumes           = any
      bind_mount_volumes    = any
    })
    load_balancer = list(object({
      target_group_arn = string
      container_name   = string
      container_port   = string
    }))
    enable_execute_command = string

  }))
}
/*variable "vpc_id" {
  type = string
}*/
//variable "container_definitions" {}
//variable "task_family" {}
//variable "execution_role_arn" {}
//variable "task_role_arn" {}
//variable "subnets" {}
//variable "security_groups" {}
//variable "container_name" {}
//variable "container_port" {}
//variable "target_group_arn" {}
