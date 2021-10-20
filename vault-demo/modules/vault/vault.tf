locals {
  vault_service_account     = "${var.project_name}-vault-sa"
}
data "template_file" "vault_values" {
  template = "${file("${path.module}/files/values.yaml.tpl")}"

  vars = {
    #vault_hostname          = var.vault_hostname
    vault_replicas          = var.vault_replicas
    aws_dynamodb_table_name = aws_dynamodb_table.vault_dynamodb_table.table_name
    aws_region              = var.aws_region
    kms_key_id              = aws_kms_key.kms_vault.key_id
    vault_secret_name       = kubernetes_secret.vault.metadata.0.name
    vault_service_account   = local.vault_service_account
    #nginx_controller_class  = "${var.nginx_controller_class}"
  }

  depends_on = [
    aws_dynamodb_table.vault_dynamodb_table,
  ]
}

resource "helm_release" "vault" {
  name       = "vault-${var.vault_environment}"
  repository = "${var.helm_repo}"
  chart      = "${var.helm_vault_chart}"
  version    = "${var.helm_vault_version}"
  namespace  = "${var.helm_vault_namespace}"

  create_namespace = true

  # values = [
  #   "${data.template_file.vault_values.rendered}",
  # ]

  depends_on = [
    aws_dynamodb_table.vault_dynamodb_table,
  ]
}
