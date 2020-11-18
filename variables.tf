variable region {
  default     = "ap-souteast-1"
  description = "AWS Region"
}

variable vpc {
  type = object({
    cidr            = string
    azs             = list(string)
    pri_sub         = list(string)
    pub_sub         = list(string)
    is_enable_natgw = bool
  })
  description = "AWS VPC Variables"
}
