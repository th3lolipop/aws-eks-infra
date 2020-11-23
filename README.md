# AWS EKS INFRA
---

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> v0.13.4 |
| aws | ~> 3.15.0 |
| kubernetes | ~> 1.9 |
| local | ~> 2.0.0 |
| random | ~> 3.0.0 |
| tls | ~> 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 3.15.0 |
| local | ~> 2.0.0 |
| random | ~> 3.0.0 |
| tls | ~> 3.0.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| eks | AWS EKS Variables | <pre>object({<br>    cluster_version         = string<br>    override_instance_types = list(string)<br>    spot_instance_pools     = number<br>    asg_max_size            = number<br>    is_public_ip            = bool<br>    asg_desire_cap          = number<br>    map_users               = list(object({ userarn = string, username = string, groups = list(string) }))<br>    map_accounts            = list(string)<br><br>  })</pre> | n/a | yes |
| key\_name | AWS Key\_pair variables | `string` | n/a | yes |
| region | AWS Region | `string` | `"ap-southeast-1"` | no |
| vpc | AWS VPC Variables | <pre>object({<br>    cidr                = string<br>    azs                 = list(string)<br>    pri_sub             = list(string)<br>    pub_sub             = list(string)<br>    is_enable_natgw     = bool<br>    is_enable_vpngw     = bool<br>    is_single_natgw     = bool<br>    is_one_natgw_per_az = bool<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| kubeconfig | Kubeconfig Output |
| private\_key | Private Pem Key |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
