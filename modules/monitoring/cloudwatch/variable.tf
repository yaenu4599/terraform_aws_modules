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

variable "email_for_sns" {
  description = "mail used fo the sns topic"
  type        = string
}

variable "retention_in_days" {
  description = "how long logs should be retained"
  type        = number
  default     = 0
}

variable "rds_storage_low_threshold" {
  description = "if only x amount of storage is left the alarm gets triggered"
  type        = number
  default     = 5 * 1024 * 1024 * 1024 # if only 5GiB is left the alarm gets triggered
}

variable "rds_instance_id" {
  description = "instance id of the rds to monitor"
  type        = string
}

variable "rds_connections_threshold" {
  description = "connections till the alarm gets triggered for db.t3.micro, change for other instance"
  type        = number
  default     = 40 # not tested yet but should be good for 1 GB Ram
}

variable "alb_arn_suffix" {
  description = "alb arn sufix for the alarm metric"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "tg arn sufix for the alarm metric"
  type        = string
}

variable "alb_5xx_threshold" {
  description = "how many 5xx erorrs in 5min, in two periods, should be allowed before the alarm gets triggered"
  type        = number
  default     = 5
}