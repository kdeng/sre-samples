output "instance_id" {
  value = aws_instance.this.id
}

output "instance_private_ip" {
  value = aws_instance.this.private_ip
}

output "instance_private_dns" {
  value = aws_instance.this.private_dns
}

output "instance_secruity_groups" {
  value = aws_instance.this.security_groups
}
