## modules/ec2instance

module to create an or multiple ec2 instances in one or more subnets

### usage

to create an inctance per private subnet use it like this
to create only a single one, only create a private or public subnet or index it

```hcl
module "ec2instance" {
  source      = "./modules/ec2instance"
  common_tags = local.common_tags
  environment = var.environment
  # public_key      = var.public_key
  instance_type     = var.instance_type
  ami_id            = var.ami_id
  subnet_ids        = module.vpc.subnets_private_ids
  security_group_id = module.security_groups.security_group_private_id
  associate_public_ip = false
}
```

###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](/docs/networking/module_vpc/doc.md) | [/modules/vpc](/modules/vpc) | vpc to provide network accessablity and basic structure |
| [security groups](/docs/security/module_security_groups/doc.md) | [/modules/security_groups](/modules/security_groups) | private security group to launch the instance in |

#### permissions

To use this module attache this policy [/docs/compute/module_ec2instance/TerraformModuleEc2Instance.json](/docs/compute/module_ec2instance/TerraformModuleEc2Instance.json) to your terraform iam user.

> *Note:* even tho the keypair is not active, the permission already gives the permission required to create/delete the keypair and import the public key
> **Note:** make sure that Managedby is eather "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work

#### others

##### <ins>__ssm managment__</ins>

to enable ssm managment for your instances you have to do the following:

1: create a aws-service role for ec2 with the policy: AmazonSSMManagedInstanceCore
2: on your deployed ec2 instance assosiate the role
3: stop and start the instance so that the role can take effect

Why do it like this? To minimize risks I do not really want to give terraform the ability to create roles or attach them.

##### <ins>__keypair for ssh__</ins>

###### __uncomment:__

variable public_key in ./variable.tf and ./terraform.tfvars

input public_key in ./main.tf module ec2instance

variable public_key in ./modules/ec2instance/variable.tf

resource "aws_key_pair" "main" in ./modules/ec2instance/main.tf

attribute key_name  in ./modules/ec2instance/main.tf

###### __after do:__ 

enter your public key in the variable publi_key in ./terraform.tfvars 

### terraform.tfvars example

```hcl
# =============================================================================
# module.ec2instance
# =============================================================================

# public_key  = "your-public-key"
instance_type = "t3.micro"
ami_id        = "ami-08bdb1495db49a7f9"
```

### inputs

| name | type | description |
|------|------|-------------|
| local.common_tags | `map(string)` | has keypears environment and managedby, ist used for tagging | 
| environment | `string` | variable used for tagging | 
| vpc_id | `string` | to define in wich vpc the security groups should be made |
| subnet_ids | `list(string)` | subnet id or ids to provision the instance |
| security_group_id | `string` | sg to provision the instance |
| associate_public_ip | `bool` | should your ec2 instance have an public ip or not |


### outputs

| name | description |
|------|-------------|
| instance_id | instance id for generale use | 