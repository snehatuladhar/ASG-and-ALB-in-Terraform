output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main_vpc.id
}

output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main_natgateway.id
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
  description = "ID of the private route table"
  value       = aws_route_table.private_route_table.id
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.server_security.id
}

output "load_balancer_dns" {
  description = "DNS name of the load balancer"
  value       = aws_lb.test.dns_name
}
