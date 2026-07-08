## modules/rds

creats:
rds instance

---

Final snapshot and multi az is turned off, for cost saving but can easly be turned on via variables.

The secrets manager module creates the credentials and stores them so the rds module just has to querry them.

### usage

```hcl
module "rds" {
  source = "./modules/rds"

  common_tags = local.common_tags
  environment = var.environment

  allocated_storage   = var.allocated_storage
  instance_class      = var.instance_class
  subnet_ids          = module.vpc.subnets_private_ids
  security_groups_ids = [module.security_groups.security_group_rds_rds_mysql_id]
  secret_id           = module.secrets_manager.secrets_creation_id

  skip_final_snapshot = true

  depends_on = [module.secrets_manager]
}
```

###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [vpc](/docs/networking/module_vpc/doc.md) | [/modules/networking/vpc/](/modules/networking/vpc/) | network to deploy the rds instance in |
| [security groups](/docs/security/module_security_groups/doc.md) | [/modules/security/security_groups/](/modules/security/security_groups/) |  psg because it required and also to control acess |
| [secrets manager](/docs/security/module_secrets_manager/)| [/modules/security/secrets_manager/](/modules/security/secrets_manager/) | for safe keeping the rds credentials, it also creates the credentials of the rds instance |

#### permissions

To use this module attache this policy [/docs/storage/module_rds/TerraformModuleRds.json](/docs/storage/module_rds/TerraformModuleRds.json) to your terraform iam user.

> **Note:** Make sure that your Managedby variable is either "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.

#### others

none

### terraform.tfvars example

```hcl
# =============================================================================
# modules.rds
# =============================================================================

allocated_storage = 10
instance_class    = "db.t3.micro"
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
| allocated_storage | `number` | storage size of db |
| instance_class | `string` | instance class of the rds |
| security_groups_ids | `list(string)` | sg ids for the rds |
| subnet_ids | `list(string)` | in what subnets the rds should be deployed in, min 2 |
| secret_id | `string` | from the secrets manager module to querry the credentials |

```hcl
variable "allocated_storage" {
  description = "storage size of db"
  type        = number
  default     = 10
}

variable "instance_class" {
  description = "instance class of the rds"
  type        = string
}

variable "security_groups_ids" {
  description = "sg ids for the rds"
  type        = list(string)
}

variable "subnet_ids" {
  description = "in what subnets the rds should be deployed in, min 2"
  type        = list(string)
}

variable "secret_id" {
  description = "from the secrets manager module to querry the credentials"
  type = string
}
```

 #### optional

| name | type | default | description |
|------|------|---------|-------------| 
| multi_az_bool | `bool` | `false` | if the rds should be multi az |
| skip_final_snapshot | `bool` | `false` | if deletion of the instance should create a final snapshot |

```hcl
variable "multi_az_bool" {
  description = "if the rds should be multi az,"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "if deletion of the instance should create a final snapshot"
  type        = bool
  default     = false
}
```

### outputs

none
