terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.9.0"
    }
  }
  required_version = "~> 1.15.0"
}
provider "aws" {
  region = "eu-central-1"
}

provider "random" {}

terraform {
  backend "s3" {
    key          = "terraform/backend/terraform_backend_bucked_v1"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
  }
}

