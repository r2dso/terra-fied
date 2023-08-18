resource "tls_private_key" "lab_priv_key" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "lab_keypair" {
  key_name   = "r2dso_lab_key"
  public_key =  tls_private_key.lab_priv_key.public_key_openssh
}

output "lab_keypair" {
  value = tls_private_key.lab_priv_key.private_key_pem
}

output "priv_key" {
    value = tls_private_key.lab_priv_key.private_key_pem
}