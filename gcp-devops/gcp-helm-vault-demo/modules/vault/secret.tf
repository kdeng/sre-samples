resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault-${var.vault_environment}"
  }
}

resource "kubernetes_secret" "vault" {
  metadata {
    name       = "vault-${var.vault_environment}"
    namespace  = "vault-${var.vault_environment}"
  }
  type = "Opaque"
  data = {
    AWS_ACCESS_KEY_ID = "${aws_iam_access_key.vault.id}"
    AWS_SECRET_ACCESS_KEY = "${aws_iam_access_key.vault.secret}"
  }
}
