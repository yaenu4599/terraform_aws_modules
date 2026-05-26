## modules/alb

Creates a fully functional ALB, currently uses HTTP (port 80) to receive and forward requests. Basic HTTPS (port 443) functionality is also available but untested and only commented.

Requires two public suvbets, with this configuration it takes the first two public subnets and no more.

### usage

```hcl

module "alb" {
  source = "./modules/alb"

  common_tags       = local.common_tags
  environment       = var.environment
  security_group_id = module.security_groups.security_group_public_id
  subnet_ids        = [module.vpc.subnets_public_ids[0], module.vpc.subnets_public_ids[1]]
  vpc_id            = module.vpc.vpc_id
}
```

###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](/docs/networking/module_vpc/doc.md) | [/modules/vpc/)](/modules/vpc/) | vpc to provide network accessablity and basic structure |
| [security groups](/docs/security/module_security_groups/doc.md) | [/modules/security_groups/](/modules/security_groups/) | public security group to launch the alb in private sg is references the public sg for inbound traffic |

#### permissions

To use this module attache this policy [/docs/compute/module_alb/TerraformModuleAlb.json](/docs/compute/module_alb/TerraformModuleAlb.json) to your terraform iam user.

> **Note:** make sure that Managedby is eather "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work
#### others

none

### terraform.tfvars example

none

### inputs

| name | type | description |
|------|------|-------------|
| local.common_tags | `map(string)` | has keypears environment and managedby, ist used for tagging | 
| environment | `string` | variable used for tagging |
| security_group_id | `string` | public sg for the alb |
| subnet_ids | `list(string)` | public subnets, min 2, to launch the albs in | 
| vpc_id | `string` | in wich vpc the resources should be deployed |

### outputs

| name | description |
|------|-------------|
| target_group_arn | tg arn for linking instances and general use |
| alb_dns_name | useful to route traffic |
