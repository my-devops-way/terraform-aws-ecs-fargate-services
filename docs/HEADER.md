# AWS ECS  Fargate multi Service Terraform Module

This module provides a straightforward approach to creating an ECS cluster with one or multiple services, each having their corresponding task definitions.


![aws_fargate_ecs](https://github.com/my-devops-way/CICD/blob/main/svg/infrastructure/ecs_fargate_bakend_frontend.svg?raw=true)

**IMPORTANT!** Please note that this module does not handle all the necessary components for running your application magically. Therefore, it is essential to create additional resources to ensure the successful operation of your application.

**Required resources:**
- Security groups.
- VPC (including subnets).

**Optional resources:**
- ALB (Application Load Balancer) with necessary target groups and rules.
- EFS (Elastic File System).
- Auto Scaling (including target and policy).
- IAM role (for task role and execution role).
- ECR (Elastic Container Registry) if not utilizing another Docker registry.
- etc
