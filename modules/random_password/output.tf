output "result" {
  description = "Generated password"
  value       = random_password.this.result
  sensitive   = true
}

output "bcrypt" {
  description = "Bcrypt hash"
  value       = random_password.this.bcrypt_hash
  sensitive   = true
}
