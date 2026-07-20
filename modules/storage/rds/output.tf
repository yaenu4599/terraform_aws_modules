output "rds_instance_id" {
  description = "id of the instance deployed"
  value = aws_db_instance.main.id
}