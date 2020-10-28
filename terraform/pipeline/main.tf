terraform {
  required_version = "~> 0.13"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 2"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 2"
    }
  }
}

provider "random" {}
