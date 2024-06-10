variable "tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
  default = {
    owner     = "sneha"
    silo      = "intern"
    terraform = "true"
  }
}

variable "instance_name" {
  description = "Value of name tag for EC2 instance"
  type        = string
  default     = "test_web_server"
}

variable "instance_ami_id" {
  description = "Default AMI id for EC2 instance (Ubuntu 22.04)"
  type        = string
  default     = "ami-04b70fa74e45c3917"
}

variable "instance_type" {
  description = "Default type for EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "db_instance_type" {
  description = "Default type for database instance"
  type        = string
  default     = "db.t3.micro"
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnet"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnet"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "vpc_cidr" {
  description = "CIDRs for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
