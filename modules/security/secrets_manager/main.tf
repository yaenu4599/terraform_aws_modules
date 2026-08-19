# =============================================================================
# secrets manager
# =============================================================================

resource "aws_secretsmanager_secret" "rds" {
  name = "rds"
  recovery_window_in_days = 0

  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-rds-credentials"
  })
}

resource "random_password" "rds_pass" {
  length           = 30
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "aws_secretsmanager_secret_version" "rds" {
  secret_id = aws_secretsmanager_secret.rds.id
  secret_string = jsonencode({
    "username" = "admin",
    "pass"     = random_password.rds_pass.result
  })
}

