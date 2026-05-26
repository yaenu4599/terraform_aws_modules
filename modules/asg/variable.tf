# =============================================================================
# tags
# =============================================================================

variable "common_tags" {
  description = "variable for correct tagging and allowing the use of the permissions given"
  type        = map(string)
}

variable "environment" {
  description = "root value for tagging"
  type        = string
}

# =============================================================================
# input
# =============================================================================

variable "subnet_ids" {
  description = "subnet ids to deploy the albs in, min 2 needed"
  type        = list(string)
}

variable "target_group_arn" {
  description = "tg arn to link the instances with"
  type        = string
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

variable "security_group_id" {
  description = "sg to assaign to the albs"
  type        = string
}

variable "instance_type" {
  description = "instance type the asg should create"
  type        = string
}

variable "ami_id" {
  description = "ami id to create the instance"
  type        = string
}


