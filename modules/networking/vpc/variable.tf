# =============================================================================
# tags
# =============================================================================

variable "common_tags" {
  description = "keypairs for tagging, has the ManagedBy tag that helps limit terraform perimissions"
  type        = map(string)
}

variable "environment" {
  description = "for overview and naming"
  type        = string
}

# =============================================================================
# input
# =============================================================================

variable "vpc_cidr" {
  description = "root passed cidr"
  type        = string
}

variable "azs" {
  description = "az list passed form the root module"
  type        = list(string)
}

variable "subnet_public_cidrs" {
  description = "cidr blocks to create public subnets"
  type = list(string)
}

variable "subnet_private_cidrs" {
  description = "cidr blocks to create private subnets"
  type = list(string)
}

# =============================================================================
# optional input
# =============================================================================

variable "region" {
  description = "used for the vpc endpoint to declair the region to use"
  type        = string
  default = "eu-central-1"
}