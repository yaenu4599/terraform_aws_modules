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

variable "allocated_storage" {
  description = "storage size of db"
  type        = number
  default     = 10
}

variable "instance_class" {
  description = "instance class of the rds"
  type        = string
}

variable "security_groups_ids" {
  description = "sg ids for the rds"
  type        = list(string)
}

variable "subnet_ids" {
  description = "in what subnets the rds should be deployed in, min 2"
  type        = list(string)
}

variable "secret_id" {
  description = "from the secrets manager module to querry the credentials"
  type = string
}

# =============================================================================
# optional
# =============================================================================

variable "multi_az_bool" {
  description = "if the rds should be multi az,"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "if deletion of the instance should create a final snapshot"
  type        = bool
  default     = false
}