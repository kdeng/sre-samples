resource "tls_private_key" "private_ssh_key" {
  algorithm   = "RSA"
}

resource "aws_key_pair" "deployer" {
  key_name    = var.instance_key_name
  public_key  = tls_private_key.private_ssh_key.public_key_openssh
  tags        = local.common_tags
}

# resource "aws_s3_bucket_object" "private_key_object" {
#   bucket = var.terraform_state_s3_bucket
#   key    = var.private_key_filename
#   content = tls_private_key.private_ssh_key.private_key_pem
# }

resource "local_file" "pem_file" {
  filename = pathexpand("${path.root}/${var.instance_key_name}.pem")
  file_permission = "600"
  directory_permission = "700"
  sensitive_content = tls_private_key.private_ssh_key.private_key_pem
}
