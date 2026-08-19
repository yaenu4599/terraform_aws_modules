output "secrets_creation_id" {
  value = aws_secretsmanager_secret.rds.id
}