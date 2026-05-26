output "asg_name" {
  description = "name for referencing"
  value       = aws_autoscaling_group.main.name
}