output "instance_id" {
  description = "instance id for generale use"
  value       = aws_instance.main[*].id
}