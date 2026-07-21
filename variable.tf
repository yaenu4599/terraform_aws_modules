# =============================================================================
# tags
# =============================================================================

variable "environment" {
  description = "Variable used for tagging"
  type        = string
  default     = "test"
}

variable "managedby" {
  description = "root value for tagging"
  type        = string
  default     = "terraform"
}

# =============================================================================
# module.vpc
# =============================================================================

variable "vpc_cidr" {
  description = "cidr to create a vpc"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "a list of azs to deploy in"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

# Currently its only possible to have one public and a private subnet to have, if there are more subnets of one kind then it only makes as man subnets as azs defined.

variable "subnet_public_cidrs" {
  description = "cidr blocks to creat public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "subnet_private_cidrs" {
  description = "cidr blocks to creat private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"] # Each private subnet gets a own natgateway, so there has to be the same amout or more public subnets as private subents.
}

# =============================================================================
# module.security_groups
# =============================================================================

variable "ssh_allowed_cidrs" {
  description = "cidr blocks allowed for ssh"
  type        = set(string)
  default     = [] # <-- add cidr blocks or leave empty to disable ssh
}

# =============================================================================
# module.ec2instance
# =============================================================================

/*
variable "public_key" {
  description = "public key for ssh( input in tvfars)"
  type = string
}
*/

variable "instance_type" {
  description = "instance type to create a instance"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "ami id to create a instance"
  type        = string
  default     = "ami-08bdb1495db49a7f9"
}

# =============================================================================
# module.asg
# =============================================================================

variable "max_size" {
  description = "asg instance limit"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "asg min instance amount"
  type        = number
  default     = 1
}

variable "desired_capacity" {
  description = "desired capacity to maintain by the asg"
  type        = number
  default     = 2
}

variable "instance_type_asg" {
  description = "instance type the asg should create"
  type        = string
  default     = "t3.micro"
}

variable "ami_asg_id" {
  description = "ami id to create the instance"
  type        = string
  default     = "ami-08bdb1495db49a7f9"
}

# =============================================================================
# module.s3
# =============================================================================

variable "bucket_name" {
  description = "unique name to create the bucket(give name in tvfars)"
  type        = string
  default     = "my-cool-terraform-bucket-version-3"
}

# =============================================================================
# module.rds
# =============================================================================

variable "allocated_storage" {
  description = "storage size of db"
  type        = number
  default     = 10
}

variable "instance_class" {
  description = "instance class of the rds"
  type        = string
  default     = "db.t3.micro"
}

# =============================================================================
# module.cloudwatch
# ============================================================================

variable "email_for_sns" {
  description = "mail used fo the sns topic"
  type = string
  default = "w2ml74j64u@ruutukf.com"
}