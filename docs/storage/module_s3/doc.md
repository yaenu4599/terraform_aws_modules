## modules/s3

create:
s3 bucket 

---

To save some money i already added a vpc endpoint to be used for the s3 bucket.

### usage

```hcl
module "s3" {
  source = "./modules/storage/s3"

  common_tags = local.common_tags
  environment = var.environment

  bucket_name = var.bucket_name
}
```

###  requirement

#### modules

none

#### permissions

To use this module attache this policy [/docs/storage/module_s3/TerraformModuleS3.json](/docs/storage/module_s3/TerraformModuleS3.json) to your terraform iam user.
Or assing it to a role and use it in your github actions with OICD.

> *Note:* Make sure when you change the name of the bucket that you also change the ARN in the policy's conditions to match. For the resource and access policy.

> **Note:** Make sure that your Managedby variable is either "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.

#### others

add the [/docs/storage/module_s3/%20S3AccessPolicy.json](/docs/storage/module_s3/%20S3AccessPolicy.json) to a role, prefered to the same role as for the ssm policy for the instances, so they can be used for launching instances so that they have access to the s3 bucked. 

> *Note:* Make sure that the rolename in the iam data block is the same to your role.

> *Note:* Make sure to change the conditions arn when changing the bucket name.

### terraform.tfvars example

```hcl
# =============================================================================
# module.s3
# =============================================================================

bucket_name   = "my-cool-terraform-bucket-version-3"
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
| bucket_name | `string` | unique name to create the bucket |

```hcl
variable "bucket_name" {
  description = "unique name to create the bucket"
  type        = string
}
```

 #### optional

 none

### outputs

| name | description |
|------|-------------|
| bucket_id | for referencing with other resources |
| bucket_arn | for creating and storing objects in the bucket |
