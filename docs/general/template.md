## modules/example

creats:


---


### usage

```hcl


```

###  requirement

#### modules

|modules | folder | description | 
|--------|--------|-------------|
|  |  |  |

#### permissions

To use this module attache this policy [/docs/example](/docs/example) to your terraform iam user.

> **Note:** Make sure that your Managedby variable is either "terraform" or you change that each permission uses the custom tag defined in Managedby, else it will not work.

#### others

none

### terraform.tfvars example

```hcl

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
|  |  |  |

```hcl

```

 #### optional

| name | type | default | description |
|------|------|---------|-------------| 
|  |  |  |  |

```hcl

```

### outputs

| name | description |
|------|-------------|
|  |  |
