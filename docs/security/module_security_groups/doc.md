## modules/security_groups

Creates a public and private security group. 

The public security group is for instances in the public subnets and allows http(80), https(443) and optionally ssh(22) when var.allow_ssh has one or more cidr_blocks defined.

The private security group is for instances in the private subnets and also allows http(80) and https(443) but both can only be accessed through a instance or Load balancer that uses the public security group.

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
| [vpc](/docs/networking/module_vpc/doc.md) | [/modules/vpc](/modules/vpc) | vpc to launche the security groups in |


#### permissions

To use this module attache this policy [/docs/security/module_security_groups/TerraformModuleSg.json](/docs/security/module_security_groups/TerraformModuleSg.json) to your terraform iam user.

> **Note:** make sure that Managedby is eather "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work

#### others

none

### terraform.tfvars example

```hcl
# =============================================================================
# module.security_groups
# =============================================================================

ssh_allowed_cidrs = []
```


### inputs

| name | type | description |
|------|------|-------------|
| local.common_tags | `map(string)` | has keypears environment and managedby, ist used for tagging | 
| environment | `string` | variable used for tagging | 
| vpc_id | `string` | to define in wich vpc the security groups should be made |
| ssh_allowed_cidrs | `set(string)` | makes it easy to allow certain cidr blocks to be used for ssh and can be left empty |


### outputs

| name | description |
|------|-------------|
| security_group_public_id | used to creat public instances |
| security_group_private_id | used to creat private instances |

