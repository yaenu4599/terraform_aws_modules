## modules/alb

Creates a fully functional ALB, currently uses HTTP (port 80) to receive and forward requests. Basic HTTPS (port 443) functionality is also available but untested and only commented.

---

Requires two public subets, with it takes the first two public subnets and no more.

### usage

```hcl

module "alb" {
  source = "./modules/alb"

  common_tags       = local.common_tags
  environment       = var.environment
  
  vpc_id            = module.vpc.vpc_id
  security_group_id = [module.security_groups.security_group_public_id]
  subnet_ids        = [module.vpc.subnets_public_ids[0], module.vpc.subnets_public_ids[1]]
}
```

###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](/docs/networking/module_vpc/doc.md) | [/modules/networking/vpc/)](/modules/networking/vpc/) | vpc to provide network accessablity and basic structure |
| [security groups](/docs/security/module_security_groups/doc.md) | [/modules/security/security_groups/](/modules/security/security_groups/) | public security group to launch the alb in private sg is references the public sg for inbound traffic |

#### permissions

To use this module attache this policy [/docs/compute/module_alb/TerraformModuleAlb.json](/docs/compute/module_alb/TerraformModuleAlb.json) to your terraform iam user.

> **Note:** Make sure that your Managedby variable is either "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.

#### others

none

### terraform.tfvars example

none

### inputs

#### module unspecified but required

| name | type | description |
|------|------|-------------|
| local.common_tags | `map(string)` | keypairs for tagging, has the ManagedBy tag that helps limit terraform perimissions | 
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
| vpc_id | `string` | Network to deploy in |
| security_group_id | `string` | sg to assaign to the alb |
| subnet_ids | `list(string)` | subnet ids to deploy the albs in, min 2 needed | 


```hcl
variable "vpc_id" {
  description = "Network to deploy in"
  type        = string
}

variable "security_group_id" {
  description = "sg to assaign to the alb"
  type        = list(string)
}

variable "subnet_ids" {
  description = "subnet ids to deploy the albs in, min 2 needed"
  type        = list(string)
}
```

 #### optional

| name | type | default | description |
|------|------|---------|-------------| 
| prevent_destroy | ``bool` | `false` | prevents deletion, only allows deletion when false |

```hcl
variable "prevent_destroy" {
  description = "prevents deletion, only allows deletion when false"
  type = bool
  default = false
}
```


### outputs

| name | description |
|------|-------------|
| target_group_arn | tg arn for linking instances and general use |
| alb_dns_name | useful to route traffic |
