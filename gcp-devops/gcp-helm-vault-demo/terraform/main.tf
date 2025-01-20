module "vault" {
  source                = "../modules/vault"
  helm_repo             = var.helm_repo
  helm_vault_chart      = var.helm_vault_chart
  helm_vault_version    = var.helm_vault_version
  helm_vault_namespace  = var.helm_vault_namespace
}
