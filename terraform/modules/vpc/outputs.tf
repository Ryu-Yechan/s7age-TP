output "vpc_id" {
  value = aws_vpc.stage_vpc.id
}

output "public_subnet_a_id" {
  value = aws_subnet.public_a.id
}

output "public_subnet_b_id" {
  value = aws_subnet.public_b.id
}

output "private_subnet_a_id" {
  value = aws_subnet.private_a.id
}

output "private_subnet_b_id" {
  value = aws_subnet.private_b.id
}

output "nat_gateway_a_id" {
  value = aws_nat_gateway.nat_a.id
}

output "nat_gateway_b_id" {
  value = aws_nat_gateway.nat_b.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "k3s_node_sg_id" {
  value = aws_security_group.k3s_node_sg.id
}

output "redis_sg_id" {
  value = aws_security_group.redis_sg.id
}

output "stage_boangroup_id" {
  value = aws_security_group.stage_boangroup.id
}
