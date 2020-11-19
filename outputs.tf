## PRIVATE PEM KEY ##
output "private_key" {
  value       = local_file.private_key.content
  description = "Private Pem Key"
}

## Kubeconfig Output ## 
output "kubeconfig" {
  value       = module.eks.kubeconfig
  description = "Kubeconfig Output"
}
