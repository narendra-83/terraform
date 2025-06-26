terraform {
  required_providers {
    tls = {
      source = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

resource "tls_private_key" "ec2_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "my-custom-ec2-key"
  public_key = tls_private_key.ec2_ssh_key.public_key_openssh
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.ec2_ssh_key.private_key_pem
  filename = "${path.module}/my-custom-ec2-key.pem"
  file_permission = "0600"
}

output "key_pair_name" {
  value       = aws_key_pair.ec2_key_pair.key_name
}

output "private_key_path" {
  value       = local_file.private_key_pem.filename
}
