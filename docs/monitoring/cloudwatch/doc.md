## modules/example

creats:

- An sns topic with an email subscription
- Cloudwatch log group "ec2"
- 2x rds cloudwatch metric alarm "high connection rate" and "low storage".
- one alb cloudwatch metric alarm " too many 5xx errors in a short amount of time"

---

I am not really sure if that module is helpful but its a test getting in the monitoring aspect of aws.

### usage

```hcl
module "cloudwatch" {
  source = "./modules/monitoring/cloudwatch"

  common_tags = local.common_tags
  environment = var.environment

  email_for_sns           = var.email_for_sns
  rds_instance_id         = module.rds.rds_instance_id
  alb_arn_suffix          = module.alb.alb_arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix
  
  #needed when using -target
  depends_on = [module.vpc, module.security_groups, module.alb, module.asg, module.rds]  
}
```

###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](/docs/networking/module_vpc/doc.md) | [/modules/networking/vpc/)](/modules/networking/vpc/) | network to deploy the asg and alb in |
| [security groups](/docs/security/module_security_groups/doc.md) | [/modules/security/security_groups/](/modules/security/security_groups/) | sg because it required and also to control acess |
 [secrets manager](/docs/security/module_secrets_manager/)| [/modules/security/secrets_manager/](/modules/security/secrets_manager/) | for safe keeping the rds credentials, it also creates the credentials of the rds instance |
| [alb](/docs/compute/module_alb/) | [/modules/compute/alb/](/modules/compute/alb/) | output is needed for the cloudwatch alarm and it makes no sense to have an alarm but no resource to it |
| [asg](/docs/compute/module_asg/doc.md) | [/modules/compute/asg/](/modules/compute/asg/) | asg for the alb |
| [rds](/docs/storage/module_rds/doc.md) | [/modules/storage/rds/](/modules/storage/rds/) | rds for the output and to also have metrics for the alarm |

#### permissions

To use this module attache this policy [/docs/monitoring/cloudwatch/TerraformModuleCloudwatch.json](/docs/monitoring/cloudwatch/TerraformModuleCloudwatch.json) to your terraform iam user.
Or assing it to a role and use it in your github actions with OICD.

> **Note:** Make sure that your Managedby variable is either "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.

#### others

none

### terraform.tfvars example

```hcl
# =============================================================================
# modules.cloudwatch
# =============================================================================

email_for_sns = <your-email-here>
```

### inputs

#### module unspecified but required

| name | type | description |
|------|------|-------------|
| common_tags | `map(string)` | keypairs for tagging, has the ManagedBy tag that helps limit terraform perimissions | 
| environment | `string` | for overview and naming | 

```hcl
variable "environment" {
  description = "keypairs for tagging, has the ManagedBy tag that helps limit terraform perimissions"
  type        = string
  default     = "dev"
}

variable "managedby" {
  description = "for overview and naming"
  type        = string
  default     = "terraform"
}
```

#### required

| name | type | description |
|------|------|-------------|
| email_for_sns | `string` | wich emails your you want to use for the sns subscription |
| rds_instance_id | `string` | instance id of the rds to monitor |
| alb_arn_suffix | `string` | alb arn sufix for the alarm metric |
| target_group_arn_suffix | `string` | tg arn sufix for the alarm metric |

```hcl
variable "email_for_sns" {
  description = "mail used fo the sns topic"
  type        = string
  default     = "<your-email-here>"
}

variable "rds_instance_id" {
  description = "instance id of the rds to monitor"
  type        = string
}

variable "alb_arn_suffix" {
  description = "alb arn sufix for the alarm metric"
  type        = string
}

variable "target_group_arn_suffix" {
  description = "tg arn sufix for the alarm metric"
  type        = string
}
```

 #### optional

| name | type | default | description |
|------|------|---------|-------------| 
| retention_in_days | `number` | `0` | how long your logs should be retained for in days |
| rds_storage_low_threshold | `number` | `5 * 1024 * 1024 * 1024 ` 5 GiB | if only x amount of storage is left the alarm gets triggered |
| rds_connections_threshold | `number` | `40`  | connections till the alarm gets triggered for db.t3.micro, change for other instance |
| alb_5xx_threshold | `number` | `5` | how many 5xx erorrs in 5min, in two periods, should be allowed before the alarm gets triggered |

```hcl
variable "retention_in_days" {
  description = "how long logs should be retained in days"
  type        = number
  default     = 0
}

variable "rds_storage_low_threshold" {
  description = "if only x amount of storage is left the alarm gets triggered"
  type        = number
  default     = 5 * 1024 * 1024 * 1024 # if only 5GiB is left the alarm gets triggered
}

variable "rds_connections_threshold" {
  description = "connections till the alarm gets triggered for db.t3.micro, change for other instance"
  type        = number
  default     = 40 # not tested yet but should be good for 1 GB Ram
}

variable "alb_5xx_threshold" {
  description = "how many 5xx erorrs in 5min, in two periods, should be allowed before the alarm gets triggered"
  type        = number
  default     = 5
}
```

### outputs

none
