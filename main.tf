provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main_vpc" {
  cidr_block = var.vpc_cidr

  tags = var.tags
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(var.tags, {
    Name = "public_subnet_${count.index + 1}"
  })
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = merge(var.tags, {
    Name = "private_subnet_${count.index + 1}"
  })
}

resource "aws_internet_gateway" "main_ig" {
  vpc_id = aws_vpc.main_vpc.id

  tags = merge(var.tags, {
    Name = "sneha_ig"
  })
}

resource "aws_eip" "nat_gateway" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name = "nat_eip"
  })
}

resource "aws_nat_gateway" "main_natgateway" {
  connectivity_type = "public"
  allocation_id     = aws_eip.nat_gateway.id
  subnet_id         = aws_subnet.public_subnets[0].id

  tags = merge(var.tags, {
    Name = "nat_gateway"
  })
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_ig.id
  }

  tags = merge(var.tags, {
    Name = "public_route_table"
  })
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.main_natgateway.id
  }

  tags = merge(var.tags, {
    Name = "private_route_table"
  })
}

resource "aws_route_table_association" "public_route_table_subnet_associations" {
  for_each       = zipmap(range(length(aws_subnet.public_subnets)), aws_subnet.public_subnets[*].id)
  subnet_id      = each.value
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "private_route_table_subnet_associations" {
  for_each       = zipmap(range(length(aws_subnet.private_subnets)), aws_subnet.private_subnets[*].id)
  subnet_id      = each.value
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_security_group" "server_security" {
  name        = "server-security-group"
  description = "Allow SSH, HTTP, and HTTPS traffic"
  vpc_id      = aws_vpc.main_vpc.id

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "server-security-group"
  })
}

resource "aws_lb" "test" {
  name               = "test-sneha"
  internal           = false
  load_balancer_type = "application"
  subnets            = aws_subnet.public_subnets[*].id
  enable_deletion_protection = false

  tags = merge(var.tags, {
    Name = "test-sneha"
  })
}
