# KMS
resource "aws_kms_key" "kms_vault" {
  description             = "kms-vault-${var.vault_environment}"
  deletion_window_in_days = 30
}

resource "aws_kms_grant" "kms_vault" {
  name              = "kms-vault-${var.vault_environment}"
  key_id            = "${aws_kms_key.kms_vault.key_id}"
  grantee_principal = "${aws_iam_user.vault.arn}"
  operations        = ["Encrypt", "Decrypt", "GenerateDataKey"]
}
