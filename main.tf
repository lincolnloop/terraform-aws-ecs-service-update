data "aws_region" "this" {}

resource "null_resource" "this" {
  triggers = zipmap(range(length(var.triggers)), var.triggers)

  provisioner "local-exec" {
    command = templatefile("${path.module}/service_update.sh.tmpl", {
      cluster         = var.cluster
      run_tasks       = var.run_tasks
      update_services = var.update_services
    })

    environment = {
      AWS_DEFAULT_REGION = data.aws_region.this.name
    }
  }
}
