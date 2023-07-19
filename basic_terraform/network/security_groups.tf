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