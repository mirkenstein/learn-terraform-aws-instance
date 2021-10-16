resource "aws_vpc" "tf_main" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
    tags = {
    Name = "tf-main-vpc"
  }
}
resource "aws_subnet" "tf_main" {
  vpc_id     = aws_vpc.tf_main.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "tf-Main-subnet"
  }
}
#resource "aws_vpc_endpoint" "my_endpoint" {
#  vpc_id      = aws_vpc.main.id
#    service_name      = "com.amazonaws.us-west-2.ec2"
#
#}
resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.tf_main.id

  ingress = [
    {
      description      = "TLS from VPC"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = [aws_vpc.tf_main.cidr_block]
     ipv6_cidr_blocks = []
      prefix_list_ids = []
      security_groups = []
      self = false

    }
  ]

  egress = [
    {
      description      = "TLS from VPC"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
      prefix_list_ids = []
      security_groups = []
      self = false
    }
  ]

  tags = {
    Name = "tf_allow_tls"
  }
}