data "local_file" "bootstrap" {
    filename = "${path.module}/bin/bootstrap.sh"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

locals {
  common_tags = {
    Project     = var.project_name
    Terraform   = true
    Environment = var.environment
  }
}

resource "aws_network_interface" "this_nti" {
  subnet_id   = var.instance_subnet
  tags = merge(local.common_tags, {
    Name = "primary_network_interface"
  })
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  disable_api_termination = var.instance_disable_api_termination
  key_name                = var.instance_key_name
  monitoring              = var.instance_monitoring
  user_data               = data.local_file.bootstrap.content

  network_interface {
    network_interface_id  = aws_network_interface.this_nti.id
    device_index          = 0
  }

  credit_specification {
    cpu_credits           = "unlimited"
  }

  root_block_device {
    volume_type = "${var.instance_root_volume_type}"
    volume_size = "${var.instance_root_volume_size}"
    delete_on_termination = true
  }

  tags = merge(local.common_tags, {
    Name        = "${var.project_name}_${var.environment}"
  })
}



