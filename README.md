# Aws_Terraform_Modules
Reusable Terraform local modules for AWS infrastructure. Made to be able to add modules easly and to export them for any use.


## modules available 

|modules | folder | description |
|--------|--------|-------------|
| [vpc](./docs/networking/module_vpc/doc.md) | [./modules/networking/vpc/](./modules/networking/vpc/) | vpc, igw, nat, subnets, route tables, s3 vpc Gwe |
| [ec2instance](./docs/compute/module_ec2instance/doc.md) | [./modules/compute/ec2instance/](./modules/compute/ec2instance/) | creates a instance in a private subnet and with a private security group |
| [alb](./docs/compute/module_alb/doc.md) | [./modules/compute/alb/](./modules/compute/alb/) | creates an alb in two azs and a tg group |
| [asg](./docs/compute/module_asg/doc.md) | [./modules/compute/asg/](./modules/compute/asg/) | creats an autoscaling group launching instances in the tg of the alb |
| [s3](./docs/storage/module_s3/doc.md) | [./modules/storage/s3/](./modules/storage/s3/) | creates a s3 bucket with versioning and encryption enabled |
| [rds](./docs/storage/module_rds/doc.md) | [./modules/storage/rds/](./modules/storage/rds/) | creates a rds instance |
| [security groups](./docs/security/module_security_groups/doc.md) | [./modules/security/security_groups/](./modules/security/security_groups/) | a public and private security group |
| [secrets_manager](./docs/security/module_secrets_manager/doc.md) | [./modules/security/secrets_manager/](./modules/security/secrets_manager/) | used to store the rds credentials also creates the credentials so that the rds module can querry them |
| [cloudwatch](./docs/monitoring/cloudwatch/doc.md) | [./modules/monitoring/cloudwatch/](./modules/monitoring/cloudwatch/) | creates an sns topic with an email subscription to get alarm notification, creates 3 alarms, 2 for rds and 1 for the alb |


### version 

| provider  | version |
|-----------|---------|
| terraform | ~> 1.15.0 |
| aws  | ~> 6.0 |
| random | ~> 3.9.0 |


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
