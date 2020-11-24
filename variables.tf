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
    database_sub        = list(string)
    is_enable_natgw     = bool
    is_enable_vpngw     = bool
    is_single_natgw     = bool
    is_one_natgw_per_az = bool
    db_sub_grp_create   = bool
    db_sub_rt_create    = bool
  })
  description = "AWS VPC Variables"
}

variable "key_name" {
  type        = string
  description = "AWS Key_pair variables"
}

variable "eks" {
  type = object({
    cluster_version         = string
    override_instance_types = list(string)
    spot_instance_pools     = number
    asg_max_size            = number
    is_public_ip            = bool
    asg_desire_cap          = number
    map_users               = list(object({ userarn = string, username = string, groups = list(string) }))
    map_accounts            = list(string)

  })
  description = "AWS EKS Variables"
}
variable "domain" {
  type        = string
  description = "External DNS"

}

variable "alb" {
  type = object({
    cluster_type = string
    namespace    = string
  })
}
variable "aws_access_key" {
  type = string
}

variable "aws_secret_key" {
  type = string
}

variable "rds" {
  type = object({
    engine         = string
    engine_version = string
    instance_class = string
    storage        = string
    db_name        = string
    db_username    = string
    db_password    = string
    db_port        = string
    family         = string
    option         = string
    deletion       = bool
    maintenance    = string
    backup         = string
  })

}