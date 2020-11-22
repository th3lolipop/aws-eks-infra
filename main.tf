resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Declaring a Local Value - Initiator 
locals {
  project_name  = join("-", ["aws-eks-infra", random_string.suffix.result])
  owner         = "OpsLAB Team"
  k8s_namespace = join("-", ["opslab-k8s", random_string.suffix.result])
}

## AWS VPC MODULE ##
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.64.0"

  name = local.project_name
  cidr = var.vpc.cidr

  azs             = var.vpc.azs
  private_subnets = var.vpc.pri_sub
  public_subnets  = var.vpc.pub_sub

  enable_nat_gateway     = var.vpc.is_enable_natgw
  enable_vpn_gateway     = var.vpc.is_enable_vpngw
  single_nat_gateway     = var.vpc.is_single_natgw
  one_nat_gateway_per_az = var.vpc.is_one_natgw_per_az

  tags = {
    Name  = local.project_name
    Owner = local.owner
  }
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
}

resource "local_file" "private_key" {
  content  = tls_private_key.this.private_key_pem
  filename = join(".", [var.key_name, "pem"])
}

## AWS KEY_PAIR MODULE ##
module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "0.5.0"

  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    Name  = local.project_name
    Owner = local.owner
  }
}

## AWS EKS ##
module "eks" {
  source          = "app.terraform.io/aws-eks-infrastructure/eks/aws"
  version         = "0.0.2"
  cluster_name    = local.project_name
  cluster_version = var.eks.cluster_version
  subnets         = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id
  map_users       = var.eks.map_users
  map_accounts    = var.eks.map_accounts
  key_name        = module.key_pair.this_key_pair_key_name

  worker_groups_launch_template = [
    {
      name                    = "worker-group-1"
      override_instance_types = var.eks.override_instance_types
      spot_instance_pools     = var.eks.spot_instance_pools
      asg_max_size            = var.eks.asg_max_size
      kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=spot"
      asg_desired_capacity    = var.eks.asg_desire_cap
      public_ip               = var.eks.is_public_ip
    },
    {
      name                    = "worker-group-2"
      override_instance_types = var.eks.override_instance_types
      spot_instance_pools     = var.eks.spot_instance_pools
      asg_max_size            = var.eks.asg_max_size
      kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=spot"
      asg_desired_capacity    = var.eks.asg_desire_cap
      public_ip               = var.eks.is_public_ip
    },
    {
      name                    = "worker-group-3"
      override_instance_types = var.eks.override_instance_types
      spot_instance_pools     = var.eks.spot_instance_pools
      asg_max_size            = var.eks.asg_max_size
      kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=spot"
      asg_desired_capacity    = var.eks.asg_desire_cap
      public_ip               = var.eks.is_public_ip
    },
  ]
}
