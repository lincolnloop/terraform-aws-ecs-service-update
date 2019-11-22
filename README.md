# terraform-aws-ecs-service-update

Terraform module to update services and run tasks on Amazon's Elastic Conainer Service (ECS).

We use this to split the full AWS Terraform configuration from the individual application configuration. The application repo can contain its own terraform files for Tasks which require a much smaller IAM footprint and can be run as part of a CI pipeline.

Once the Task Definitions are updated, this module can be used to update the service and run any necessary one-off tasks for the deployment. Only the cluster and service names need to be passed in as variables.

## Requirements

This module makes use of the `awscli`. [Install documentation can be found here](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html).

## Usage


```hcl-terraform
# Define some tasks
resource "aws_ecs_task_definition" "example" {
  container_definitions = jsonencode([{
    name    = "example"
    image   = alpine
    command = ["/bin/echo", "hello world"]
  }])
  family             = "example"
  execution_role_arn = var.execution_role_arn
}
# ...

module "update-example" {
  source = "github.com/lincolnloop/terraform-aws-ecs-service-update"
  # Run this whenever any of these values change
  triggers = [aws_ecs_task_definition.example.arn]
  cluster  = var.cluster_name
  # One-off tasks to run during deployment
  run_tasks = [aws_ecs_task_definition.another-task.arn]
  # Services to update with the new task definitions
  update_services = [{
    name     = var.service_name
    task_arn = aws_ecs_task_definition.example.arn
  }]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster | Name of the ECS cluster | string | - | yes |
| run_tasks | A list of Task ARNs to run | list(string) | `[]` | no |
| triggers | Properties that, when changed, should trigger the execution of this module | list(string) | `[]` | no |
| update_services | A list of objects with the ECS Service name (`name`) and the updated Task Definition ARN (`task_arn`) | list(object) | `[]` | no |
