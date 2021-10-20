data "aws_iam_policy_document" "kms_vault" {
  statement {
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
  }
}

resource "aws_iam_user_policy" "kms_vault" {
  name   = "kms-vault-${var.vault_environment}"
  user   = "${aws_iam_user.vault.name}"
  policy = "${data.aws_iam_policy_document.kms_vault.json}"
}

resource "aws_iam_user" "vault" {
  name = "vault-${var.vault_environment}"
  path = "/system/"
}

resource "aws_iam_access_key" "vault" {
  user = "${aws_iam_user.vault.name}"
}

# Post Passwords Parameter store

resource "aws_ssm_parameter" "vault_aws_secret_id" {
  name        = "vault-${var.vault_environment}-aws-secret-id"
  description = "vault-${var.vault_environment}-aws-secret-id"
  type        = "SecureString"
  value       = "${aws_iam_access_key.vault.id}"
}

resource "aws_ssm_parameter" "vault_aws_secret_key" {
  name        = "vault-${var.vault_environment}-aws-secret-key"
  description = "vault-${var.vault_environment}-aws-secret-key"
  type        = "SecureString"
  value       = "${aws_iam_access_key.vault.secret}"
}
