// Configure Terraform providers
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

// Define AWS provider configuration
provider "aws" {
  region = var.region  
}

// Include modules for specific configurations

module "vpc" {
  source = "lily4499/eks-v1/aws//vpc"
  version = ">= 1.0.0, < 2.0.0"
  vpc_id = module.vpc.vpc_id
  vpc_cidr       = var.vpc_cidr
  dns_hostnames  = var.dns_hostnames
  dns_support    = var.dns_support
  pub_one_cidr   = var.pub_one_cidr
  pub_two_cidr   = var.pub_two_cidr
  priv_one_cidr  = var.priv_one_cidr
  priv_two_cidr  = var.priv_two_cidr
} 




module "eks" {
  source = "lily4499/eks-v1/aws//eks"
  version = ">= 1.0.0, < 2.0.0"
  vpc_id = module.vpc.vpc_id

  vpc_cidr       = var.vpc_cidr
  dns_hostnames  = var.dns_hostnames
  dns_support    = var.dns_support
  pub_one_cidr   = var.pub_one_cidr
  pub_two_cidr   = var.pub_two_cidr
  priv_one_cidr  = var.priv_one_cidr
  priv_two_cidr  = var.priv_two_cidr

  cluster_name                = var.cluster_name
  eks_version                 = var.eks_version
  private_subnet_ids          = module.vpc.private_subnet_ids
  public_subnet_ids           = module.vpc.public_subnet_ids
  ami_type                    = var.ami_type
  instance_types              = var.instance_types
  capacity_type               = var.capacity_type
}



