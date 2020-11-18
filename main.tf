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
