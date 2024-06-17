variable "tags" {
  description = "Common tags to be applied to all resources"
  type        = map(string)
}

variable "instance_name" {
  description = "Value of name tag for EC2 instance"
  type        = string
}

variable "instance_ami_id" {
  description = "Default AMI id for EC2 instance (Ubuntu 22.04)"
  type        = string
}

variable "instance_type" {
  description = "Default type for EC2 instance"
  type        = string
}

variable "db_instance_type" {
  description = "Default type for database instance"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "CIDRs for private subnet"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnet"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "CIDRs for VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type        = list(string)
}

