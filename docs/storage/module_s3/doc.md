## modules/s3

module to create an s3 bucket 

### usage

```hcl
module "s3" {
  source      = "./modules/s3"
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

> *Note:* make sure when you change the name of the bucked that you also change the arn in the policy to match

> **Note:** make sure that Managedby is eather "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work

#### others

So that ec2 instances have access to the bucked add this policy to role and give it to the instance [/docs/storage/module_s3/%20S3AccessPolicy.json](/docs/storage/module_s3/%20S3AccessPolicy.json)

> *Note:* make sure when you change the name of the bucked that you also change the arn, in the policy, to match

### terraform.tfvars example

```hcl
# =============================================================================
# module.s3
# =============================================================================

bucket_name          = "my-cool-terraform-bucket-version-3"
```

### inputs

| name | type | description |
|------|------|-------------|
| local.common_tags | `map(string)` | has keypears environment and managedby, ist used for tagging | 
| environment | `string` | variable used for tagging | 
| bucket_name | `string` | set unique bucket name to use for the module |


### outputs

| name | description |
|------|-------------|
| bucket_id | for referencing with other resources |
| bucket_arn | for creating and storing objects in the bucket |
