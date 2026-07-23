## modules/asg

creats:
launch template
Auto Scaling Group
Target Group

---

Basic Auto Scaling Group using the Target Group to be Availabile to The Application Load Balancer.

Scale out and Scale in with cloudwatch  using the CPUUtilisation metric.
Currently has min, desired and max capacity at 2, change the variables or tfvars to test it.

Pulls the current amazon 2023 ami (x86_64)(via data block) and is supported till 2029 [source](https://docs.aws.amazon.com/linux/al2023/ug/release-cadence.html).

### usage

```hcl
module "asg" {
  source = "./modules/compute/asg"

  common_tags       = local.common_tags
  environment       = var.environment

  subnet_ids        = module.vpc.subnets_private_ids
  target_group_arn  = module.alb.target_group_arn
  max_size          = var.max_size
  min_size          = var.min_size
  desired_capacity  = var.desired_capacity
  instance_type     = var.instance_type_asg
  security_group_id = [module.security_groups.security_group_private_id]

  #needed when using -target
  depends_on = [module.vpc, module.security_groups]
}
```

###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](/docs/networking/module_vpc/doc.md) | [/modules/networking/vpc/)](/modules/networking/vpc/) | network to deploy the asg in |
| [security groups](/docs/security/module_security_groups/doc.md) | [/modules/security/security_groups/](/modules/security/security_groups/) | sg because it required and also to control acess |
| [alb](/docs/compute/module_alb/) | [/modules/compute/alb/](/modules/compute/alb/) | its made to be used with the lb, can be used without but the tg arn has to be removed |

#### permissions

To use this module attache this policy [/docs/compute/module_asg/TerraformModuleAsg.json](/docs/compute/module_asg/TerraformModuleAsg.json) to your terraform iam user.
Or assing it to a role and use it in your github actions with OICD.

> **Note:** Make sure that your Managedby variable is either "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.

#### others

none

### terraform.tfvars example

```hcl
# =============================================================================
# module.asg
# =============================================================================

max_size          = 2
min_size          = 2
desired_capacity  = 2
instance_type_asg = "t3.micro"
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
| target_group_arn | `string`  | used to put the instances in the tg |
| subnet_ids | `list(string)` | subnet ids to deploy instances in, eiter a public subnet or a private, to be used with alb use private | 
| max_size | `number` | max instances asg can scale |
| min_size | `number` | min instances asg can maintain |
| desired_capacity | `number` | desired capacity |
| instance_type | `string` | instance_type asg should use for deployment |
| security_group_id | `list(string)` | public sg for the alb |

```hcl
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
```

 #### optional

### outputs

| name | description |
|------|-------------|
| asg_name | "name for referencing" |
