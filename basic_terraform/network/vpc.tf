resource "aws_vpc" "r2dso-lab_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "r2dso-lab_subnet" {
  vpc_id = aws_vpc.r2dso-lab_vpc.id
  cidr_block = "10.0.1.0/24"
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