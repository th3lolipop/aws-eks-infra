## PRIVATE PEM KEY ##

output "private_key" {
  value       = local_file.private_key.content
  description = "Private Pem Key"
}
