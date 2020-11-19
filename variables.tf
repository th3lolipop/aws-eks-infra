variable region {
  default     = "ap-southeast-1"
  description = "AWS Region"
}

variable vpc {
  type = object({
    cidr                = string
    azs                 = list(string)
    pri_sub             = list(string)
    pub_sub             = list(string)
    is_enable_natgw     = bool
    is_enable_vpngw     = bool
    is_single_natgw     = bool
    is_one_natgw_per_az = bool
  })
  description = "AWS VPC Variables"
}

variable "key_name" {
  type        = string
  description = "AWS Key_pair variables"
}

variable "eks" {
  type = object({
    cluster_version = string
    instance_type   = list(string)
    is_public_ip    = bool
    asg_desire_cap  = number
    map_users       = list(object({ userarn = string, username = string, group = list(string) }))
    map_accounts    = list(string)
  })
  description = "AWS EKS Variables"
}

