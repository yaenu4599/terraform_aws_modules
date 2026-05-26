## modules/asg

Basic Auto Scaling Group using the Target Group to be Availabile to The Application Load Balancer.

Scale out and Scale in does not to anything yet, eather a basic Target Tracking Scaling Policy can be made or wait for the CloudWatch module.

Currently has min and desired capacity at 2 and max at 3.

### usage

```hcl
module "asg" {
  source = "./modules/asg"

  common_tags       = local.common_tags
  environment       = var.environment
  target_group_arn  = module.alb.target_group_arn
  subnet_ids        = module.vpc.subnets_private_ids
  max_size          = var.max_size
  min_size          = var.min_size
  desired_capacity  = var.desired_capacity
  instance_type     = var.instance_type_asg
  ami_id            = var.ami_asg_id
  security_group_id = module.security_groups.security_group_private_id
}
```

###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](/docs/networking/module_vpc/doc.md) | [/modules/vpc/)](/modules/vpc/) | vpc to provide network accessablity and basic structure |
| [security groups](/docs/security/module_security_groups/doc.md) | [/modules/security_groups/](/modules/security_groups/) |  private subnets to launch the ec2 instances in, currently it spreads acording to subnets given |
| [alb](/docs/compute/module_alb/) | [/modules/alb/](/modules/alb/) | its made to be used with the lb, can be used without but the tg arn has to be removed |

#### permissions

To use this module attache this policy [/docs/compute/module_asg/TerraformModuleAsg.json](/docs/compute/module_asg/TerraformModuleAsg.json) to your terraform iam user.

> **Note:** make sure that Managedby is eather "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work
#### others

none

### terraform.tfvars example

```hcl
# =============================================================================
# module.asg
# =============================================================================

max_size          = 3
min_size          = 2
desired_capacity  = 2
instance_type_asg = "t3.micro"
ami_asg_id        = "ami-08bdb1495db49a7f9"+
```

### inputs

| name | type | description |
|------|------|-------------|
| local.common_tags | `map(string)` | has keypears environment and managedby, ist used for tagging | 
| environment | `string` | variable used for tagging | 
| target_group_arn | `string`  | used to put the instances in the tg |
| subnet_ids | `list(string)` | public subnets, min 2, to launch the albs in | 
| max_size | `number` | max instances asg can scale |
| min_size | `number` | min instances asg can maintain |
| desired_capacity | `number` | desired capacity |
| instance_type | `string` | instance_type asg should use for deployment |
| ami_id | `string` | ami asg should use do deploy instances |
| security_group_id | `string` | public sg for the alb |
| vpc_id | `string` | in wich vpc the resources should be deployed |

### outputs

| name | description |
|------|-------------|
| asg_name | "name for referencing" |
