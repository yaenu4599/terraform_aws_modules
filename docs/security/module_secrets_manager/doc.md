## modules/example

creats:
A secreat that hold the rds credentials that gets created after with the username "admin" and a random password.

---

Only holds one rds credential keypair.

### usage

```hcl
module "secrets_manager" {
  source = "./modules/secrets_manager"

  common_tags = local.common_tags
  environment = var.environment
}
```

###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
| [rds](/docs/storage/module_rds/doc.md) | [/modules/rds/](/modules/rds/) | requried because its made to be used with the rds module |

#### permissions

To use this module attache this policy [/docs/security/module_secrets_manager/TerraformModuleSecretsManager.json](/docs/security/module_secrets_manager/TerraformModuleSecretsManager.json) to your terraform iam user.

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

none

 #### optional

none

### outputs

| name | description |
|------|-------------|
| secrets_creation_id | used to querry the credentials in the rds module |
