resource "aws_db_subnet_group" "default_subnet_group" {
  name       = "default_subnet_group_db"
  subnet_ids = aws_subnet.private_subnets[*].id
}

resource "aws_db_instance" "private_db" {
  db_name              = "app_db"
  identifier           = "terraform-20240606090204339500000006"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"         # Adjust the engine version as per the supported versions
  instance_class       = "db.t3.micro" # Choose a supported instance class
  username             = "sneha"
  password             = "sneha12345"
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.default_subnet_group.name
  tags = {
    Name = "MyDB"
  }
}
