# =============================================================================
# rds
# =============================================================================

data "aws_secretsmanager_secret_version" "fetch" {
  secret_id = var.secret_id
}

locals {
  credentials = jsondecode(data.aws_secretsmanager_secret_version.fetch.secret_string)
}

resource "aws_db_subnet_group" "rds" {
  name       = "${var.environment}-rds-main"
  subnet_ids = var.subnet_ids

  tags = merge(var.common_tags,
    {
      Name = "${var.environment}-rds-main"
  })
}

resource "aws_db_instance" "main" {
  allocated_storage      = var.allocated_storage
  db_name                = "mydb"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.instance_class
  db_subnet_group_name   = aws_db_subnet_group.rds.name
  vpc_security_group_ids = var.security_groups_ids
  username               = local.credentials["username"]
  password               = local.credentials["pass"]
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = var.skip_final_snapshot
  multi_az               = var.multi_az_bool

  tags = merge(var.common_tags,
    {
      Name = "main-${var.environment}-rds-db"
  })
}