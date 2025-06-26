data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "public_web_server" {
  ami                         = data.aws_ami.amazon_linux_2.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.public_ec2_sg.id]
  key_name                    = aws_key_pair.ec2_key_pair.key_name
  associate_public_ip_address = true

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo amazon-linux-extras install nginx1 -y
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>Hello from Public EC2 (NGINX)</h1>" | sudo tee /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "PublicWebServer"
  }
}

output "public_ec2_ip" {
  value       = aws_instance.public_web_server.public_ip
}

resource "aws_instance" "private_app_server" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.private_ec2_sg.id]
  key_name               = aws_key_pair.ec2_key_pair.key_name

  tags = {
    Name = "PrivateAppServer"
  }
}

output "private_ec2_private_ip" {
  value       = aws_instance.private_app_server.private_ip
}
