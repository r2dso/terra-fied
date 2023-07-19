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