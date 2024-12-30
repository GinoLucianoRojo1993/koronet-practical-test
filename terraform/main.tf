provider "aws" {
  region = "us-west-2"
}

# Create a VPC for EKS
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name                 = "eks-vpc"
  cidr                 = "10.0.0.0/16"
  azs                  = ["us-west-2a", "us-west-2b"]
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets       = ["10.0.3.0/24", "10.0.4.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  public_subnet_tags   = { "kubernetes.io/role/elb" = "1" }
  private_subnet_tags  = { "kubernetes.io/role/internal-elb" = "1" }
}

# Create an EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "18.0.0"

  cluster_name    = "koronet-cluster"
  cluster_version = "1.24"

  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.private_subnets

  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1

      instance_type    = "t3.medium"
    }
  }

  manage_aws_auth = true
}

# Outputs
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eks_cluster_id" {
  value = module.eks.cluster_id
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  value = module.eks.node_security_group_id
}
