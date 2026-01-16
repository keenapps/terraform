output "id" {
  description = "Full random pet name (e.g., 'happy-duck')"
  value       = random_pet.this.id
}

output "separator" {
  description = "Separator used"
  value       = random_pet.this.separator
}
