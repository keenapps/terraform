output "result" {
  description = "The generated random string"
  value       = random_string.this.result
}

output "result_b64" {
  description = "Base64 encoded version"
  value       = random_string.this.b64_result
  sensitive   = true
}
