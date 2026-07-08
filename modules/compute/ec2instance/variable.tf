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

variable "instance_type" {
  description = "wich instance type to use"
  type        = string
}

variable "ami_id" {
  description = "wich ami should be used"
  type        = string
}

variable "subnet_ids" {
  description = "subnet id or ids, either public or private subnets"
  type        = list(string)
}


variable "security_group_ids" {
  description = "wich sg the instance should have, corresponding with the subnet"
  type        = list(string)
}


# =============================================================================
# optional
# ======================================================================

variable "associate_public_ip" {
  description = "if the instance should have a public ip or not"
  type        = bool
  default     = false
}

/*
variable "public_key" {
  description = "public key to use as keypair for the instance"
  type        = string
}
*/


