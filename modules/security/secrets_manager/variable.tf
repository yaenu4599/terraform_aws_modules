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

