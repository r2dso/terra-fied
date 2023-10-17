# Additional security group to expose port 22
resource "aws_security_group" "allow_ssh" {
  count = var.weak_enabled ? 1 : 0
  vpc_id      = var.lab_vpc
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# provide an option to enable this module
# if the variable "enabled" is true create a simple ec2 instance

resource "aws_instance" "weak-example" {
  count = var.weak_enabled ? 1 : 0
  ami           = "ami-06ca3ca175f37dd66"
  instance_type = "t2.micro"
  vpc_security_group_ids = compact([var.lab_sgs, count.index == 0 ? aws_security_group.allow_ssh[0].id : ""])
  subnet_id = var.lab_subnet

  associate_public_ip_address = true

  tags = {
      Name = "r2dso-lab-instance-weak"
      Vulnerable = "true"
  }

  iam_instance_profile = var.instance_profile

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

output "public_ip_weak_instance" {
  value = length(aws_instance.weak-example) > 0 ? aws_instance.weak-example[0].public_ip : null
}

output "weak_instance_id" {
  value = length(aws_instance.weak-example) > 0 ? aws_instance.weak-example[0].id : null
}
