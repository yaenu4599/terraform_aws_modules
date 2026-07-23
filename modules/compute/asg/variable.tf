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

variable "target_group_arn" {
  description = "tg arn to link the instances with"
  type        = string
}

variable "subnet_ids" {
  description = "subnet ids to deploy instances in, eiter a public subnet or a private, to be used with alb use private"
  type        = list(string)
}

variable "max_size" {
  description = "asg instance limit"
  type        = number
  default     = 2
}

variable "min_size" {
  description = "asg min instance amount"
  type        = number
  default     = 2
}

variable "desired_capacity" {
  description = "desired capacity to maintain by the asg"
  type        = number
  default     = 2
}

variable "instance_type" {
  description = "instance type the asg should create"
  type        = string
}

variable "security_group_id" {
  description = "sg to assaign to the albs"
  type        = list(string)
}

