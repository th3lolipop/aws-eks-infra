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

  enable_nat_gateway = var.vpc.is_enable_natgw

  tags = {
    Name  = local.project_name
    Owner = local.owner
  }
}

resource "tls_private_key" "this" {
   algorithm = "RSA"
}

resource "local_file" "private_key" {
    content     = tls_private_key.this.private_key_pem
    filename = join(".", [var.key_name, "pem"])
}

## AWS KEY_PAIR MODULE ##
module "key_pair" {
  source = "terraform-aws-modules/key-pair/aws"
  version = "0.5.0"

  key_name = var.key_name
  public_key = tls_private_key.this.public_key_openssh

  tags = {
    Name = local.project_name
    Owner = local.owner
  }
}
