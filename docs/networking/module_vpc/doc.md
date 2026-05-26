## modules/vpc

Creates a full vpc setup with public and private subnets across multiple azs(optionally). 

For each cidr provided in var.subnet_public_cidrs and var.subnet_private_cidrs, one public and one private subnet will be created, up to the number of AZs defined in var.azs — whichever is fewer.

Each private subnet gets its own nat gateway (deployed in the corresponding public subnet) and an associated route table that routes outbound traffic through it.
If no private cidrs are provided, no private subnets or nat gateways will be created, public subnet can be disabled the same way.

Both public and private subnets have access to an vpc gateway endpoint for s3.

### usage

```hcl
module "vpc" {
  source               = "./modules/vpc"

  common_tags          = local.common_tags
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  azs                  = var.azs
  region               = "eu-central-1" # optional, default "eu-central-1"
  subnet_public_cidrs  = var.subnet_public_cidrs
  subnet_private_cidrs = var.subnet_private_cidrs
}
```


###  requirement

#### modules

none

#### permissions

To use this module attache this policy [/docs/networking/module_vpc/TerraformModuleVpc.json](/docs/networking/module_vpc/TerraformModuleVpc.json) to your terraform iam user.

> **Note:** make sure that Managedby is eather "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work

#### other

none

### terraform.tfvars example

```hcl
# =============================================================================
# modules.vpc
# =============================================================================

vpc_cidr = "10.0.0.0/16"
azs      = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]

# subnet_public_cidrs and subnet_private_cidrs must have the same number of entries as azs
subnet_public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
subnet_private_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
```


### inputs

| name | type | description |
|------|------|-------------|
| local.common_tags | `map(string)` | has keypears environment and managedby, ist used for tagging | 
| environment | `string` | variable used for tagging | 
| vpc_cidr | `string` | cidr to create a vpc |
| azs | `list(string)` | a list of azs to deploy in |
| region | `string` | used for the s3 vpc enpoint, to define in wich region to deploy | 
| subnet_public_cidrs | `list(string)` | cidr blocks to create public subnets |
| subnet_private_cidrs | `list(string)` | cidr blocks to create private subnets |


### outputs

| name | description |
|------|-------------|
| vpc_id | vpc id to use in the root module or and in other modules |
| subnets_public_ids | the ids of the public subnets in the vpc, in a list |
| subnets_private_ids | the ids of the private subnets in the vpc, in a list |
