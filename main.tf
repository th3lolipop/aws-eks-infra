resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Declaring a Local Value - Initiator 
locals {
  project_name   = join("-", ["aws-eks-infra", random_string.suffix.result])
  owner          = "OpsLAB Team"
  k8s_namespace  = join("-", ["opslab-k8s", random_string.suffix.result])
  security_group = join("-", ["opslab-eks-sg", random_string.suffix.result])
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

## AWS Security Group For ALB ##
module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.16.0"

  name = local.security_group

  description = "Security group for EKS ALB"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp"]
  egress_cidr_blocks  = ["0.0.0.0/0"]
  egress_rules        = ["all-all"]
  tags = {
    Name = local.security_group
  }
}

## AWS ALB ##
#module "alb" {
#  source  = "terraform-aws-modules/alb/aws"
#  version = "5.9.0"
#
#  name = local.project_name
#
#  load_balancer_type = "application"
#
#  vpc_id          = module.vpc.vpc_id
#  subnets         = module.vpc.public_subnets
#  security_groups = [module.sg.this_security_group_id]
#
#  target_groups = [
#    {
#      name_prefix      = "pref-"
#      backend_protocol = "HTTP"
#      backend_port     = 80
#      target_type      = "instance"
#    }
#  ]
#
#  http_tcp_listeners = [
#    {
#      port               = 80
#      protocol           = "HTTP"
#      target_group_index = 0
#    }
#  ]
#
#  tags = {
#    Name = local.project_name
#  }
#}

## AWS Kubernetes External DNS ## 
#data "aws_iam_role" "eks_worker_node" {
#  name = "eks_external_dns"
#}

module "external-dns" {
  source  = "DTherHtun/external-dns/aws"
  version = "0.1.8"

  domain           = var.domain
  k8s_cluster_name = module.eks.cluster_id
}

module "alb" {
  source                             = "dtherhtun/alb/kubernetes"
  version                            = "0.0.2"
  aws_alb_ingress_controller_version = "1.1.7"
  k8s_cluster_name                   = module.eks.cluster_id
  aws_vpc_id                         = module.vpc.vpc_id
  k8s_cluster_type                   = var.alb.cluster_type
  aws_assess_key_id                  = var.aws_access_key
  aws_secret_access_key              = var.aws_secret_key
  region                             = var.region
  k8s_namespace                      = var.alb.namespace
}
