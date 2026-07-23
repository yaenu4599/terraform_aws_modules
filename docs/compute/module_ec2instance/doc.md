## modules/ec2instance

Creates one or multiple ec2 instances in one or more subnets.

---

Per subnet one instance gets created. Depents on the `subnet_ids` variable, so if multiple subnets exists but only one instance should be created, index the variable. 
either give the private or public subnets to deploy the instances in.

Pulls the current amazon 2023 ami (x86_64)(via data block) and is supported till 2029 [source](https://docs.aws.amazon.com/linux/al2023/ug/release-cadence.html).

### usage

```hcl
module "ec2instance" {
  source              = "./modules/compute/ec2instance"

  common_tags         = local.common_tags
  environment         = var.environment

  instance_type       = var.instance_type
  subnet_ids          = module.vpc.subnets_private_ids
  security_group_id   = [module.security_groups.security_group_private_id] 
  associate_public_ip = false
  #public_key         = var.public_key

  #needed when using -target
  depends_on = [module.vpc, module.security_groups]
}
```

###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](/docs/networking/module_vpc/doc.md) | [/modules/networking/vpc](/modules/networking/vpc) | vpc to provide network accessablity and basic structure |
| [security groups](/docs/security/module_security_groups/doc.md) | [/modules/security/security_groups](/modules/security/security_groups) | private or public security group to launch the instances in |

#### permissions

To use this module attache this policy [/docs/compute/module_ec2instance/TerraformModuleEc2Instance.json](/docs/compute/module_ec2instance/TerraformModuleEc2Instance.json) to your terraform iam user.
Or assing it to a role and use it in your github actions with OICD.

> *Note:* Even tho the keypair is not active, the permission already gives the right required to create/delete the keypair and import the public key.

> **Note:** Make sure that your Managedby variable is either "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.

#### others

1) create a role with the policy [/docs/compute/module_ec2instance/TerraformModuleEc2Instance.json](/docs/compute/module_ec2instance/TerraformModuleEc2Instance.json).

2) change the data block to use the name of the role

> **Note:** Make sure to add the role name at the bott of of the policy, in the resources. Needed to keep security over the "passrole" permission.

### terraform.tfvars example

```hcl
# =============================================================================
# module.ec2instance
# =============================================================================

instance_type = "t3.micro"
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
| instance_type | `string` | wich instance type to use |
| subnet_ids | `list(string)` | subnet id or ids, either public or private subnets |
| security_group_ids | `list(string)` | wich sg the instance should have, corresponding with the subnet |


```hcl
variable "instance_type" {
  description = "wich instance type to use"
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
