module "network" {
  source = "./modules/network"
    participant_ip = "${local.public_ip_data}/32"
}
module "keys" {
  source = "./modules/keys"
}
module "instances" {
  source = "./modules/instances"
  key_name = module.keys.lab_keypair
  priv_key = module.keys.priv_key
  lab_vpc = module.network.r2dso-lab-vpc
  lab_sgs = module.network.r2dso-lab-sg
  lab_subnet = module.network.r2dso-lab-subnet
  remoteexec_enabled = var.remoteexec_enabled
  weak_enabled = var.weak_enabled
  instance_profile = aws_iam_instance_profile.r2dso_lab_execution_instance_profile.name
  nc_ip = aws_instance.r2dso_lab_instance.public_ip
}

resource "aws_instance" "r2dso_lab_instance" {
  ami = "ami-0b69ea66ff7391e80" // Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [module.network.r2dso-external_sg]
  subnet_id = module.network.r2dso-external_subnet
  associate_public_ip_address = true

  # provisioner "file" {
  #   source      = "prepare_my_instance.sh"
  #   destination = "/tmp/prepare.sh"
  #   connection {
  #     type        = "ssh"
  #     user        = "ubuntu"
  #     private_key = file(var.private_key_path)
  #     host        = self.public_ip
  #   }
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /tmp/prepare.sh",
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = "ec2-user"
  #     private_key = ""
  #     host        = self.public_ip
  #   }
  # }
  tags = {
    Name = "r2dso-exlab-instance"
  }
}

output "r2dso-lab-pub-ip" {
  value = aws_instance.r2dso_lab_instance.public_ip
}

resource "null_resource" "setup_local" {
  provisioner "local-exec" {
    command = "echo 'ZmlsZV9uYW1lPSIuL2xhYl9wcml2YXRlX2tleS5wZW0iCmlmIFtbIC1mIC4vJGZpbGVfbmFtZSBdXTsgdGhlbgogICAgZGVza3RvcF9wYXRoPSIke0hPTUV9L0Rlc2t0b3AiCiAgICBjcCAuLyRmaWxlX25hbWUgJGRlc2t0b3BfcGF0aAogICAgZWNobyAiRmlsZSAkZmlsZV9uYW1lIGhhcyBiZWVuIG1vdmVkIHRvICRkZXNrdG9wX3BhdGgiCmVsc2UKICAgIGVjaG8gIkZpbGUgJGZpbGVfbmFtZSBkb2VzIG5vdCBleGlzdCBpbiB0aGUgY3VycmVudCB3b3JraW5nIGRpcmVjdG9yeS4iCmZpCg==' | base64 --decode | bash"
  }

  depends_on = [
    aws_instance.r2dso_lab_instance
  ]
}

output "public_ip_remoteexec" {
  value = var.remoteexec_enabled ? module.instances.public_ip_remoteexec : null
}
