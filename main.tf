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
  source = "./modules/vpc"

  common_tags          = local.common_tags
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  region               = "eu-central-1" # optional
  subnet_public_cidrs  = var.subnet_public_cidrs
  subnet_private_cidrs = var.subnet_private_cidrs
}

# =============================================================================
# security
# =============================================================================

module "security_groups" {
  source = "./modules/security_groups"

  common_tags = local.common_tags
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  allow_ssh   = var.ssh_allowed_cidrs
}

# =============================================================================
# compute
# =============================================================================

/* #commented out because i already create instances with the asg

module "ec2instance" {
  source      = "./modules/ec2instance"

  common_tags = local.common_tags
  environment = var.environment
  # public_key      = var.public_key
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  subnet_ids        = module.vpc.subnets_private_ids
  security_group_id = module.security_groups.security_group_private_id
  associate_public_ip = false
}
*/

module "asg" {
  source = "./modules/asg"

  common_tags       = local.common_tags
  environment       = var.environment
  target_group_arn  = module.alb.target_group_arn
  subnet_ids        = module.vpc.subnets_private_ids
  max_size          = var.max_size
  min_size          = var.min_size
  desired_capacity  = var.desired_capacity
  instance_type     = var.instance_type_asg
  ami_id            = var.ami_asg_id
  security_group_id = module.security_groups.security_group_private_id
}

module "alb" {
  source = "./modules/alb"

  common_tags       = local.common_tags
  environment       = var.environment
  security_group_id = module.security_groups.security_group_public_id
  subnet_ids        = [module.vpc.subnets_public_ids[0], module.vpc.subnets_public_ids[1]]
  vpc_id            = module.vpc.vpc_id
}

# =============================================================================
# storage
# =============================================================================

/*
module "s3" {
  source = "./modules/s3"

  common_tags = local.common_tags
  environment = var.environment
  bucket_name = var.bucket_name
}
*/