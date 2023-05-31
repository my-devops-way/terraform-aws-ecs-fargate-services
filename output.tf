output "cluster_arn" {
  value       = aws_ecs_cluster.this.arn
  description = "ARN that identifies the cluster."
}
output "service_id" {
  value       = aws_ecs_service.this[*].id
  description = "(List) ARNs that identifies the services."
}
output "service_name" {
  value       = aws_ecs_service.this[*].name
  description = "(List) Names of the services."
}
output "task_definition_arn" {
  value       = aws_ecs_task_definition.this[*].arn
  description = "(List) Full ARN of the Task Definition (including both family and revision)."
}
output "task_definition_arn_without_revision" {
  value       = aws_ecs_task_definition.this[*].arn_without_revision
  description = "(List) ARNs of the Task Definitions with the trailing revision removed. This may be useful for situations where the latest task definition is always desired. If a revision isn't specified, the latest ACTIVE revision is used. See the AWS documentation for details."
}
output "task_definition_revision" {
  value       = aws_ecs_task_definition.this[*].revision
  description = "(List) Revisions of the tasks in a particular family."
}
