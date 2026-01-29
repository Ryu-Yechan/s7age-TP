output "alb_arn" {
  value = aws_lb.stage_alb.arn
}

output "alb_dns_name" {
  value = aws_lb.stage_alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.k3s_ingress.arn
}

output "target_group_id" {
  value = aws_lb_target_group.k3s_ingress.id
}