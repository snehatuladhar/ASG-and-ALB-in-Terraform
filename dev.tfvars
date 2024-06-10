tags = {
  owner     = "sneha"
  silo      = "intern"
  terraform = "true"
}

instance_name = "test_web_server"
instance_ami_id = "ami-04b70fa74e45c3917"
instance_type = "t2.micro"
db_instance_type = "db.t3.micro"
private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
vpc_cidr = "10.0.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b"]
