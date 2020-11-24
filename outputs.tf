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

## AWS RDS output ##
output "database_instance_address" {
  value       = module.rds.this_db_instance_address
  description = "Database Instance Address"
}

output "database_connection_endpoint" {
  value       = module.rds.this_db_instance_endpoint
  description = "Database Connection Endpoint"
}

output "database_username" {
  value       = module.rds.this_db_instance_username
  description = "Database Username"
}

output "database_password" {
  value       = module.rds.this_db_instance_password
  description = "Database Password"
  sensitive   = true
}

output "eks_security_group" {
  value       = module.eks.worker_security_group_id
  description = "EKS Security Group"
}