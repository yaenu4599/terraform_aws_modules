output "security_group_public_id" {
  description = "the security gorup id for the public sg to use for the root module"
  value       = aws_security_group.public.id
}

output "security_group_private_id" {
  description = "the security gorup id for the private sg to use for the root module"
  value       = aws_security_group.private.id
}

output "security_group_rds_rds_mysql_id" {
  description = "the security gorup id for the rds sg to use for the root module"
  value       = aws_security_group.rds_mysql.id
}

