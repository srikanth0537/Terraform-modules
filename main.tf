# Creating apache webserver by calling modules

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.36.0"
    }
  }
}

provider "aws" {
  region = var.region
  # Configuration options
}

resource "aws_instance" "ec2_server" {

  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.pv-sg.id]

  tags = {
    "name" = "webserver-for-apache"
  }

  user_data = <<-EOF
        #!/bin/sh
        sudo apt-get update
        sudo apt install -y apache2
        sudo systemctl status apache2
        sudo systemctl start apache2
        sudo chown -R $USER:$USER /var/www/html
        sudo echo "<html><body><h1> Hello this is module-1 at instance id created by srikanth nukala `curl http://169.254.169.254/latest/meta-data/instance-id` </h1></body></html>" > /var/www/html/index.html
        EOF

}

resource "aws_security_group" "pv-sg" {
  name        = "apache-server-sg"
  description = "Webserver for EC2 to install apache ws"

  ingress {
    from_port   = 80
    protocol    = "TCP"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    protocol    = "TCP"
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}




