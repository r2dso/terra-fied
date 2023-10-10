variable "key_name" {
  description = "Name of the SSH key to use for EC2 instances"
}
variable "remoteexec_enabled" {
    type = bool
}

variable "weak_enabled" {
    type = bool
}

provider "aws" {
  region = "us-west-2"
}

data "aws_ami" "latest_amazon_linux" {
  most_recent = true

  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

output "ami_id" {
  description = "The ID of the latest Amazon Linux 2 AMI"
  value       = data.aws_ami.latest_amazon_linux.id
}