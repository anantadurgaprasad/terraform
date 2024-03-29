
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = ">5.0.0"
    }
    tls = {
        source = "hashicorp/tls"
        version = "~>4.0.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }

  }
}

# Configure the AWS Provider
provider "aws" {
  
  region     = var.region
 
}