module "network" {
  source = "./modules/network"
    participant_ip = "${local.public_ip_data.ip}/32"
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
  nc_ip = aws_instance.r2dso_lab_instance.public_ip
}

resource "null_resource" "fetch_public_ip" {
  provisioner "local-exec" {
    command = "curl -s ifconfig.co/json > public_ip.json"
  }
  triggers = {
    always_run = "${timestamp()}"
  }
}
resource "aws_instance" "r2dso_lab_instance" {
  ami = "ami-0b69ea66ff7391e80" // Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [module.network.r2dso-external_sg]
  subnet_id = module.network.r2dso-external_subnet
  associate_public_ip_address = true

  tags = {
    Name = "r2dso-exlab-instance"
  }
}

output "r2dso-lab-pub-ip" {
  value = aws_instance.r2dso_lab_instance.public_ip
}

output "public_ip_remoteexec" {
  value = var.remoteexec_enabled ? module.instances.public_ip_remoteexec : null
}
