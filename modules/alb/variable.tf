# =============================================================================
# tags
# =============================================================================

variable "common_tags" {
  description = "variable for correct tagging and allowing the use of the permissions given"
  type        = map(string)
}

variable "environment" {
  description = "variable form the root module for correct tagging"
  type        = string
}

# =============================================================================
# input
# =============================================================================

variable "vpc_id" {
  description = "vpc import form the vpc module"
  type        = string
}

variable "security_group_id" {
  description = "sg to assaign to the albs"
  type        = string
}

variable "subnet_ids" {
  description = "subnet ids to deploy the albs in, min 2 needed"
  type        = list(string)
}

# =============================================================================
# optional input
# =============================================================================

variable "prevent_destroy" {
  description = "prevents deletion, only allows deletion when false"
  type = bool
  default = false
}

