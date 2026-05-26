# Aws_Terraform_Modules
Reusable Terraform local modules for AWS infrastructure. Made to be able to add modules easly and to export them for any use.


## modules available 

|modules | folder | description |
|--------|--------|-------------|
| [vpc](./docs/networking/module_vpc/doc.md) | [./modules/vpc](./modules/vpc) | vpc, igw, nat, subnets, route tables, s3 vpc Gwe |
| [security groups](./docs/security/module_security_groups/doc.md) | [./modules/security_groups](./modules/security_groups) | a public and private security group |
| [ec2instance](./docs/storage/module_s3/doc.md) | [./modules/ec2instance/](./modules/ec2instance/) | creates a instance in a private subnet and with a private security group |
| [s3](./docs/module_s3/doc.md) | [./modules/s3/](./modules/s3/) | creates a s3 bucket with versioning and encryption enabled |
| [alb](./docs/compute/module_alb/doc.md) | [./modules/alb/](./modules/alb/) | creates an alb in two azs and a tg group |
| [asg](./docs/compute/module_asg/doc.md) | [./modules/asg/](./modules/asg/) | creats an autoscaling group launching instances in the tg of the alb |

### version 

| provider  | version |
|-----------|---------|
| terraform | ~> 1.15.0 |
| aws  | ~> 6.0 |


### permissions

Attache this policy [./docs/general/TerraformBasicPermissions.json](./docs/general/TerraformBasicPermissions.json) to your terraform iam user.

> **Note:** The policy uses `ManagedBy = "terraform"` as a resource tag condition
> All resources created by this module must include this tag in `common_tags`, or update the condition value in the policy to match your tagging convention


### terraform.tfvars.example

```hcl
# =============================================================================
# tag
# =============================================================================

environment = "dev"
managedby   = "terraform"
```