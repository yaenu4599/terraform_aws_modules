# =============================================================================
# tag
# =============================================================================

locals {
  environment = var.environment
  managedby   = var.managedby

  common_tags = {
    Environment = local.environment
    ManagedBy   = local.managedby
  }
}

# =============================================================================
# networking
# =============================================================================

module "vpc" {
  source = "./modules/networking/vpc"

  common_tags = local.common_tags
  environment = var.environment

  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  subnet_public_cidrs  = var.subnet_public_cidrs
  subnet_private_cidrs = var.subnet_private_cidrs
}

# =============================================================================
# security
# =============================================================================

module "security_groups" {
  source = "./modules/security/security_groups"

  common_tags = local.common_tags
  environment = var.environment

  vpc_id = module.vpc.vpc_id
}

module "secrets_manager" {
  source = "./modules/security/secrets_manager"

  common_tags = local.common_tags
  environment = var.environment
}

# =============================================================================
# compute
# =============================================================================

module "ec2instance" {
  source = "./modules/compute/ec2instance"

  common_tags = local.common_tags
  environment = var.environment

  instance_type       = var.instance_type
  ami_id              = var.ami_id
  subnet_ids          = module.vpc.subnets_private_ids
  security_group_ids  = [module.security_groups.security_group_private_id]
  associate_public_ip = false
  #public_key         = var.public_key
}


module "asg" {
  source = "./modules/compute/asg"

  common_tags = local.common_tags
  environment = var.environment

  target_group_arn  = module.alb.target_group_arn
  subnet_ids        = module.vpc.subnets_private_ids
  max_size          = var.max_size
  min_size          = var.min_size
  desired_capacity  = var.desired_capacity
  instance_type     = var.instance_type_asg
  ami_asg_id        = var.ami_asg_id
  security_group_id = [module.security_groups.security_group_private_id]

  depends_on = [module.vpc]
}

module "alb" {
  source = "./modules/compute/alb"

  common_tags = local.common_tags
  environment = var.environment

  vpc_id            = module.vpc.vpc_id
  security_group_id = [module.security_groups.security_group_public_id]
  subnet_ids        = [module.vpc.subnets_public_ids[0], module.vpc.subnets_public_ids[1]]

  depends_on = [ module.vpc ]
}

# =============================================================================
# storage
# =============================================================================


module "s3" {
  source = "./modules/storage/s3"

  common_tags = local.common_tags
  environment = var.environment

  bucket_name = var.bucket_name
}

module "rds" {
  source = "./modules/storage/rds"

  common_tags = local.common_tags
  environment = var.environment

  allocated_storage   = var.allocated_storage
  instance_class      = var.instance_class
  subnet_ids          = module.vpc.subnets_private_ids
  security_groups_ids = [module.security_groups.security_group_rds_rds_mysql_id]
  secret_id           = module.secrets_manager.secrets_creation_id

  skip_final_snapshot = true

  depends_on = [module.secrets_manager]
}