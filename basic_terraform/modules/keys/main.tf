resource "tls_private_key" "example" {
  algorithm = "RSA"
}

resource "local_sensitive_file" "lab_private_key" {
  content = tls_private_key.example.private_key_pem
  filename          = "lab_private_key.pem"
  file_permission   = "0777"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = tls_private_key.example.public_key_openssh
}

module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  key_name   = "deployer-three"
  public_key = tls_private_key.example.public_key_openssh
}

output "public_key" {
  value     = tls_private_key.example.public_key_openssh
}

output "lab_keypair" {
  value =  aws_key_pair.deployer.key_name
}

output "priv_key" {
  value = local_sensitive_file.lab_private_key.filename
}