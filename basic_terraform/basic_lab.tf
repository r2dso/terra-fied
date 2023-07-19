provider "aws" {
  region = "us-east-1"
}

variable "key_name" {
  description = "Name of the SSH key to use for EC2 instances"
}

resource "aws_vpc" "r2dso-lab_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "r2dso-lab_subnet" {
  vpc_id = aws_vpc.r2dso-lab_vpc.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_security_group" "r2dso-lab_sg" {
  name_prefix = "r2dso-lab_sg"
  vpc_id = aws_vpc.r2dso-lab_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "r2dso-lab_instance" {
  ami = "ami-0b69ea66ff7391e80" // Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t2.micro"
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.r2dso-lab_sg.id]
  subnet_id = aws_subnet.r2dso-lab_subnet.id
  associate_public_ip_address = true

  tags = {
    Name = "r2dso-lab-instance"
  }
}

resource "aws_internet_gateway" "r2dso-lab_igw" {
  vpc_id = aws_vpc.r2dso-lab_vpc.id
}

resource "aws_route_table" "r2dso-lab_route_table" {
  vpc_id = aws_vpc.r2dso-lab_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.r2dso-lab_igw.id
  }
}

resource "aws_route_table_association" "r2dso-lab_subnet_association" {
  subnet_id = aws_subnet.r2dso-lab_subnet.id
  route_table_id = aws_route_table.r2dso-lab_route_table.id
}

output "r2dso-lab_public_ip" {
  value = aws_instance.r2dso-lab_instance.public_ip
}