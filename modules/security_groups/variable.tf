# =============================================================================
# tags
# =============================================================================

variable "common_tags" {
  description = "keypairs for tagging, has the ManagedBy tag that helps limit terraform perimission"
  type        = map(string)
}

variable "environment" {
  description = "for overview and naming"
  type        = string
}

# =============================================================================
# input
# =============================================================================

variable "vpc_id" {
  description = "vpc id to deploy the security gorups in"
  type        = string
}
# =============================================================================
# optional
# =============================================================================

variable "allow_ssh" {
  description = "a set of cidr blocks to allow ssh with"
  type        = set(string)
  default     = []
}