variable "run_tasks" {
  description = "One-off tasks to run as a list of Task ARNs"
  type        = list(string)
  default     = []
}

variable "cluster" {
  description = "ECS Cluster name"
}

variable "update_services" {
  description = "A list of Service names and Task ARNs that they should be updated to."
  type = list(object({
    name     = string
    task_arn = string
  }))
}

variable "triggers" {
  default = "Trigger the update whenever the items in this list change (usually Task ARNs)"
  type    = list(string)
}
