output "target_group_arn" {
  description = "tg arn for linking instances and general use"
  value = aws_lb_target_group.main.arn
}

output "alb_dns_name" {
  description = "useful to route traffic"
  value = aws_lb.main.dns_name
}