terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.33.0"
    }
  }
}


  # Configuration options
 provider "aws" {
    region = "us-east-1"
    profile = "stephen-dev"
}