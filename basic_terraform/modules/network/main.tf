# Creates a VPC with a public subnet, internet gateway, route table, and security group.

# Define the VPC with a standard CIDR block
resource "aws_vpc" "r2dso-lab_vpc" {
  cidr_block = "10.0.0.0/16"
}

# Define the subnet with a standard CIDR block within the VPC
resource "aws_subnet" "r2dso-lab_subnet" {
  vpc_id = aws_vpc.r2dso-lab_vpc.id
  cidr_block = "10.0.1.0/24"
}

# Define the Internet Gateway using the VPC ID
resource "aws_internet_gateway" "r2dso-lab_igw" {
  vpc_id = aws_vpc.r2dso-lab_vpc.id
}

# Create a route table for the VPC
resource "aws_route_table" "r2dso-lab_route_table" {
  vpc_id = aws_vpc.r2dso-lab_vpc.id

  #Create a route for the Internet Gateway going to the public internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.r2dso-lab_igw.id
  }
}

# Associate the subnet with the route table
resource "aws_route_table_association" "r2dso-lab_subnet_association" {
  subnet_id = aws_subnet.r2dso-lab_subnet.id
  route_table_id = aws_route_table.r2dso-lab_route_table.id
}

# Create a security group for the VPC that allows SSH and HTTP traffic
resource "aws_security_group" "r2dso-lab_sg" {
  name_prefix = "r2dso-lab_sg"
  vpc_id = aws_vpc.r2dso-lab_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "r2dso-weak_sg" {
  name        = "ec2-tf-testing"
  description = "SG for use with terraform testing"

  ingress {
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
# Ouput the security group and subnet IDs to be used by the EC2 instance
output "r2dso-lab-sg" {
  value = aws_security_group.r2dso-lab_sg.id
}

output "r2dso-weak-sg" {
  value = aws_security_group.r2dso-weak_sg.id
}
output "r2dso-lab-subnet" {
  value = aws_subnet.r2dso-lab_subnet.id
}

output "r2dso-lab-vpc" {
  value = aws_vpc.r2dso-lab_vpc.id
}

# Creates a VPC with a public subnet, internet gateway, route table, and security group.

# Define the VPC with a standard CIDR block
resource "aws_vpc" "r2dso-external_vpc" {
  cidr_block = "192.168.0.0/16"
}

# Define the subnet with a standard CIDR block within the VPC
resource "aws_subnet" "r2dso-external_subnet" {
  vpc_id = aws_vpc.r2dso-external_vpc.id
  cidr_block = "192.168.10.0/24"
}

# Define the Internet Gateway using the VPC ID
resource "aws_internet_gateway" "r2dso-external_igw" {
  vpc_id = aws_vpc.r2dso-external_vpc.id
}

# Create a route table for the VPC
resource "aws_route_table" "r2dso-external_route_table" {
  vpc_id = aws_vpc.r2dso-external_vpc.id

  #Create a route for the Internet Gateway going to the public internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.r2dso-external_igw.id
  }
}

# Associate the subnet with the route table
resource "aws_route_table_association" "r2dso-external_subnet_association" {
  subnet_id = aws_subnet.r2dso-external_subnet.id
  route_table_id = aws_route_table.r2dso-external_route_table.id
}

# Create a security group for the VPC that allows SSH and HTTP traffic
resource "aws_security_group" "r2dso-external_sg" {
  name_prefix = "r2dso-external_sg"
  vpc_id = aws_vpc.r2dso-external_vpc.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.participant_ip]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "r2dso-external_sg" {
  value = aws_security_group.r2dso-external_sg.id
}

output "r2dso-external_subnet" {
  value = aws_subnet.r2dso-external_subnet.id
}

output "r2dso-external_vpc" {
  value = aws_vpc.r2dso-external_vpc.id
}