terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # opcional: se quiser salvar estado localmente, não precisa mudar nada
  # se for usar backend remoto (ex: S3), substitua aqui
}

provider "aws" {
  region = "us-east-1"
}

# Cria uma VPC mínima (necessário, pois EC2 requer rede)
resource "aws_vpc" "demo" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tf-demo-vpc"
  }
}

resource "aws_subnet" "demo" {
  vpc_id                  = aws_vpc.demo.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"

  tags = {
    Name = "tf-demo-subnet"
  }
}

resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.demo.id

  tags = {
    Name = "tf-demo-igw"
  }
}

resource "aws_route_table" "demo" {
  vpc_id = aws_vpc.demo.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo.id
  }

  tags = {
    Name = "tf-demo-rt"
  }
}

resource "aws_route_table_association" "demo" {
  subnet_id      = aws_subnet.demo.id
  route_table_id = aws_route_table.demo.id
}

resource "aws_security_group" "demo" {
  name        = "tf-demo-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = aws_vpc.demo.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol
