# Creating VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = var.tags
}

# Creating public subnets
resource "aws_subnet" "public" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags              = var.tags
}

# Creating private subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.availability_zones, count.index)
  tags              = var.tags
}

# Creating Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = var.tags
}

# Creating route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = var.tags
}

# Associating public subnets with route table
resource "aws_route_table_association" "a" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Creating security group for EC2
resource "aws_security_group" "instance" {
  vpc_id = aws_vpc.main.id
  tags   = var.tags

  ingress {
    from_port   = 80
    to_port     = 80
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

# Creating EC2 instance
resource "aws_instance" "web" {
  ami                         = var.instance_ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(aws_subnet.public.*.id, 0)
  vpc_security_group_ids      = [aws_security_group.instance.id]
  tags                        = merge(var.tags, { Name = var.instance_name })
}

# Creating RDS subnet group
resource "aws_db_subnet_group" "default_subnet_group" {
  name       = "default_subnet_group_db"
  subnet_ids = aws_subnet.private.*.id
  tags       = var.tags
}

# Creating RDS instance
resource "aws_db_instance" "private_db" {
  db_name              = "app_db"
  identifier           = "terraform-20240606090204339500000006"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.db_instance_type
  username             = local.db_username
  password             = local.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.default_subnet_group.name
  tags                 = merge(var.tags, { Name = "MyDB" })
}

# Creating ALB
resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.instance.id]
  subnets            = aws_subnet.public.*.id
  tags               = merge(var.tags, { Name = "AppLoadBalancer" })
}

# Creating Target Group
resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  tags     = merge(var.tags, { Name = "AppTargetGroup" })
}

# Creating Listener
resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

# Creating Launch Template
resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-launch-template-"
  image_id      = var.instance_ami_id
  instance_type = var.instance_type
  tags = {
    Name = "AppLaunchTemplate"
  }
  tag_specifications {
    resource_type = "instance"
    tags          = var.tags
  }
}

# Creating Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  desired_capacity     = 1
  max_size             = 3
  min_size             = 1
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }
  vpc_zone_identifier = aws_subnet.public.*.id
  target_group_arns   = [aws_lb_target_group.app_tg.arn]
  tags = [
    {
      key                 = "Name"
      value               = "AppInstance"
      propagate_at_launch = true
    }
  ]
}

