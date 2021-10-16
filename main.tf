terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "app_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.tf_main.id
associate_public_ip_address = true
  tags = {
    Name = var.instance_name
  }
  vpc_security_group_ids  = [aws_security_group.allow_tls.id]
}

resource "aws_route53_zone" "example" {
  name = "test.dfh.ai"
    vpc {
    vpc_id = aws_vpc.tf_main.id
  }
}


resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "es1"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.app_server.private_ip]
}

