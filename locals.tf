locals {
  instance_name        = var.instance_name
  instance_ami_id      = var.instance_ami_id
  instance_type        = var.instance_type
  db_instance_type     = var.db_instance_type
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  db_password          = var.db_password
  db_username          = var.db_username
  db_name              = var.db_name
}
