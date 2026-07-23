output "target_group_arn" {
  description = "tg arn for linking instances and general use"
  value = aws_lb_target_group.main.arn
}

output "alb_arn" {
  description = "arn of the alb for general use"
  value = aws_lb.main.arn
}

output "alb_dns_name" {
  description = "useful to route traffic"
  value = aws_lb.main.dns_name
}

output "target_group_arn_suffix" {
  description = "tg suffix arn for general use"
  value = aws_lb_target_group.main.arn_suffix
}

output "alb_arn_suffix" {
  description = "arn suffix of the alb for general use"
  value = aws_lb.main.arn_suffix
}

