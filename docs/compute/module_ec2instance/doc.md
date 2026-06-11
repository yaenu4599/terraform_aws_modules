## modules/ec2instance

Creates one or multiple ec2 instances in one or more subnets.

---

Per subnet one instance gets created. Depents on the `subnet_ids` variable, so if multiple subnets exists but only one instance should be created, index the variable. 

either give the private or public subnets to deploy the instances in.

### usage

```hcl
module "ec2instance" {
  source              = "./modules/ec2instance"

  common_tags         = local.common_tags
  environment         = var.environment

  instance_type       = var.instance_type
  ami_id              = var.ami_id
  subnet_ids          = module.vpc.subnets_private_ids
  security_group_id   = [module.security_groups.security_group_private_id] 
  associate_public_ip = false
  #public_key         = var.public_key
}
```

###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](/docs/networking/module_vpc/doc.md) | [/modules/vpc](/modules/vpc) | vpc to provide network accessablity and basic structure |
| [security groups](/docs/security/module_security_groups/doc.md) | [/modules/security_groups](/modules/security_groups) | private or public security group to launch the instance in |

#### permissions

To use this module attache this policy [/docs/compute/module_ec2instance/TerraformModuleEc2Instance.json](/docs/compute/module_ec2instance/TerraformModuleEc2Instance.json) to your terraform iam user.

> *Note:* Even tho the keypair is not active, the permission already gives the right required to create/delete the keypair and import the public key.

> **Note:** Make sure that your Managedby variable is either "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.

#### others

##### <ins>__ssm managment__</ins>

to enable ssm managment for your instances you have to do the following:

1: create a aws-service role for ec2 with the policy: AmazonSSMManagedInstanceCore
2: on your deployed ec2 instance assosiate the role
3: stop and start the instance so that the role can take effect

Why do it like this? To minimize risks I do not really want to give terraform the ability to create roles or attach them. (for now till there is a better solution)

---

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

instance_type = "t3.micro"
ami_id        = "ami-08bdb1495db49a7f9"
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
| instance_type | `string` | wich instance type to use |
| ami_id | `string` | wich ami should be used |
| subnet_ids | `list(string)` | subnet id or ids, either public or private subnets |
| security_group_ids | `list(string)` | wich sg the instance should have, corresponding with the subnet |


```hcl
variable "instance_type" {
  description = "wich instance type to use"
  type        = string
}

variable "ami_id" {
  description = "wich ami should be used"
  type        = string
}

variable "subnet_ids" {
  description = "subnet id or ids, either public or private subnets"
  type        = list(string)
}


variable "security_group_ids" {
  description = "wich sg the instance should have, corresponding with the subnet"
  type        = list(string)
}
```

#### optional

| name | type | default | description |
|------|------|---------|-------------| 
| associate_public_ip | `bool` | `false` | if the instace should have a public ip or not |
| public_key | `string` | commented | public key to use as keypair for the instance |

```hcl
variable "associate_public_ip" {
  description = "if the instance should have a public ip or not"
  type        = bool
  default     = false
}

variable "public_key" {
  description = "public key to use as keypair for the instance"
  type        = string
}

```

### outputs

| name | description |
|------|-------------|
| instance_id | instance id for generale use | 
