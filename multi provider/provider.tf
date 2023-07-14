terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
        version = "3.65.0"
    }
    aws = {
        source = "hashicorp/aws"
        version = "5.8.0"
    }
  }
}
provider "azurerm" {
    features {}
}
provider "aws" {
    region = "us-east-1"
  
}