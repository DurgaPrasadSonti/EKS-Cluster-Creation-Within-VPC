#terraform {
  #required_providers {
    #aws = {
      #source  = "hashicorp/aws"
      #version = "~> 5.0"
    #}
  #}

  #backend "s3" {
    #bucket         = "Prasad-demo-eks-vpc-bucket"
   #key            = "terraform.tfstate"
    #region         = "us-west-2"
    #use_lockfile  = true 
    #encrypt        = true
  #}
#}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "git::https://github.com/DurgaPrasadSonti/EKS-Cluster-Creation-Within-VPC.git//modules/VPC"

  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  private_subnet_cidrs = var.private_subnet_cidrs
  public_subnet_cidrs  = var.public_subnet_cidrs
  cluster_name         = var.cluster_name
}

module "eks" {
  source = "git::https://github.com/DurgaPrasadSonti/EKS-Cluster-Creation-Within-VPC.git//modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnet_ids
  node_groups     = var.node_groups
}

