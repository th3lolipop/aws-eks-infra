# AWS EKS INFRA

## Requirements

| Name | Version |
|------|---------|
| terraform | ~> v0.13.4 |
| aws | ~> 3.15.0 |
| local | ~> 2.0.0 |
| random | ~> 3.0.0 |
| tls | ~> 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| local | ~> 2.0.0 |
| random | ~> 3.0.0 |
| tls | ~> 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| key\_name | AWS Key\_pair variables | `string` | n/a | yes |
| region | AWS Region | `string` | `"ap-southeast-1"` | no |
| vpc | AWS VPC Variables | <pre>object({<br>    cidr                = string<br>    azs                 = list(string)<br>    pri_sub             = list(string)<br>    pub_sub             = list(string)<br>    is_enable_natgw     = bool<br>    is_enable_vpngw     = bool<br>    is_single_natgw     = bool<br>    is_one_natgw_per_az = bool<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| private\_key | Private Pem Key |
