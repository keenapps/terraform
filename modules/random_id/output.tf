output "id" {
  description = "Full resource ID (hash)"
  value       = random_id.this.id
}

output "hex" {
  description = "Hex string (e.g., 'a1b2c3d4')"
  value       = random_id.this.hex
}

output "b64" {
  description = "Base64 string"
  value       = random_id.this.b64
}

output "dec" {
  description = "Decimal number"
  value       = random_id.this.dec
}
