## modules/security_groups

creats:
public sg
private sg
rds mysql sg

---

Creates a public, private security group and a mysql rds db security group. 

The public security group is for instances in the public subnets and allows http(80), https(443) and optionally ssh(22) when `var.allow_ssh has` one or more cidr_blocks defined.

The private security group is for instances in the private subnets and also allows http(80) and https(443) but both can only be accessed through a instance or Load balancer that uses the public security group.

The rds mysql security group allows the port 3306(MySQL DB) and references the private subnet so other instances in the private subnet can access the rds.

### usage

```hcl
module "security_groups" {
  source      = "./modules/security_groups"
  
  common_tags = local.common_tags
  environment = var.environment

  vpc_id      = module.vpc.vpc_id

  allow_ssh   = var.ssh_allowed_cidrs
}
```


###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](/docs/networking/module_vpc/doc.md) | [/modules/networking/vpc](/modules/networking/vpc) | vpc to launche the security groups in |


#### permissions

To use this module attache this policy [/docs/security/module_security_groups/TerraformModuleSg.json](/docs/security/module_security_groups/TerraformModuleSg.json) to your terraform iam user.

> **Note:** Make sure that your Managedby variable is either "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.

#### others

none

### terraform.tfvars example

Only if needed:

```hcl
# =============================================================================
# module.security_groups
# =============================================================================

ssh_allowed_cidrs = []
```


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
| vpc_id | `string` | vpc id to deploy the security gorups in |

```hcl
variable "vpc_id" {
  description = "vpc import form the vpc module"
  type        = string
}
```

 #### optional

| name | type | default | description |
|------|------|---------|-------------| 
| allow_ssh | `set(string)` | `[]` | a set of cidr blocks to allow ssh with |

```hcl
variable "allow_ssh" {
  description = "a cidr blocks or a set, to allow ssh with"
  type        = set(string)
  default     = []
}
```

### outputs

| name | description |
|------|-------------|
| security_group_public_id | used to creat public instances |
| security_group_private_id | used to creat private instances |
| security_group_rds_mysql_id | used to create an rds mysql db for accessing the db | 
