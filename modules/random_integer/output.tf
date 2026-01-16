output "result" {
  description = "Random integer from min-max range"
  value       = random_integer.this.result
}

output "id" {
  description = "Resource ID (hash)"
  value       = random_integer.this.id
}
