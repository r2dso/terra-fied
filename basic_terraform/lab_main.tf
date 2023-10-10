module "network" {
  source = "./modules/network"
}
module "keys" {
  source = "./modules/keys"
}
module "instances" {
  source = "./modules/instances"
  key_name = module.keys.lab_keypair
  priv_key = module.keys.priv_key
  remote_exec_sgs = module.network.r2dso-lab-sg
  remote_exec_subnet = module.network.r2dso-lab-subnet
  remoteexec_enabled = var.remoteexec_enabled
  weak_enabled = var.weak_enabled
  nc_ip = aws_instance.r2dso_lab_instance.public_ip
}

resource "aws_instance" "r2dso_lab_instance" {
  ami = "ami-0b69ea66ff7391e80" // Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [module.network.r2dso-lab-sg]
  subnet_id = module.network.r2dso-lab-subnet
  associate_public_ip_address = true

  tags = {
    Name = "r2dso-lab-instance"
  }
}

output "r2dso-lab-pub-ip" {
  value = aws_instance.r2dso_lab_instance.public_ip
}

output "public_ip_remoteexec" {
  value = var.remoteexec_enabled ? module.instances.public_ip_remoteexec : null
}
