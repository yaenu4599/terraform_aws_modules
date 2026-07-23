## modules/vpc

creats:
vpc
subnet/s
internet gateway
nat gateway/s
routes
routetable/s
vpc endpoint for s3

---

Creates a vpc setup with public and private subnets across multiple azs(optionally). 

For each cidr provided in `var.subnet_public_cidrs` and `var.subnet_private_cidrs`, one public and one private subnet will be created, up to the number of azs defined in var.azs — whichever is fewer. Per az max one public and private subnet.

Each private subnet gets its own nat gateway (deployed in the corresponding public subnet) and an associated route table that routes outbound traffic through it, so ever private subnets needs an public subnet where the nat gets deployed.

If no private cidrs are provided, no private subnets or nat gateways will be created, public subnet can be disabled the same way.

Both public and private subnets have access to an vpc gateway endpoint for s3.

### usage

```hcl
module "vpc" {
  source               = "./modules/networking/vpc"

  common_tags          = local.common_tags
  environment          = var.environment

  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  subnet_public_cidrs  = var.subnet_public_cidrs
  subnet_private_cidrs = var.subnet_private_cidrs

  #optional

  region               = "eu-central-1" 
}
```

###  requirement

#### modules

none

#### permissions

To use this module attache this policy [/docs/networking/module_vpc/TerraformModuleVpc.json](/docs/networking/module_vpc/TerraformModuleVpc.json) to your terraform iam user.
Or assing it to a role and use it in your github actions with OICD.

> **Note:** Make sure that your Managedby variable is either "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.

#### other

none

### terraform.tfvars example

```hcl
# =============================================================================
# modules.vpc
# =============================================================================

vpc_cidr = "10.0.0.0/16"
azs      = ["eu-central-1a", "eu-central-1b""]
subnet_public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24""]
subnet_private_cidrs = ["10.0.4.0/24", "10.0.5.0/24""]
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
| vpc_cidr | `string` | network cidr block |
| azs | `list(string)` | a list of azs to deploy in |
| subnet_public_cidrs | `list(string)` | cidr blocks to create public subnets |
| subnet_private_cidrs | `list(string)` | cidr blocks to create private subnets |

```hcl
variable "vpc_cidr" {
  description = "cidr to create a vpc"
  type        = string
  default     = "10.0.0.0/16"
}

# Currently its only possible to have one public and a private subnet to have, if there are more subnets of one kind then it only makes as man subnets as azs defined.

variable "azs" {
  description = "a list of azs to deploy in"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
}

variable "subnet_public_cidrs" {
  description = "cidr blocks to creat public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Each private subnet gets a own natgateway, so there has to be the same amout or more public subnets as private subents.

variable "subnet_private_cidrs" {
  description = "cidr blocks to creat private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}
```

 #### optional

| name | type | default | description |
|------|------|---------|-------------| 
| region | `string` | `eu-central-1` | used for the s3 vpc enpoint, to define in wich region to deploy |

```hcl
variable "region" {
  description = "used for the vpc endpoint to declair the region to use"
  type        = string
  default = "eu-central-1"
}
```

### outputs

| name | description |
|------|-------------|
| vpc_id | vpc id to use in the root module or and in other modules |
| subnets_public_ids | the ids of the public subnets in the vpc, in a list |
| subnets_private_ids | the ids of the private subnets in the vpc, in a list |
