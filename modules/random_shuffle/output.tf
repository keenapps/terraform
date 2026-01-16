output "result" {
  description = "Shuffled list (full or subset)"
  value       = random_shuffle.this.result
}

output "id" {
  description = "Resource ID (hash)"
  value       = random_shuffle.this.id
}

output "first" {
  description = "First shuffled item"
  value       = length(random_shuffle.this.result) > 0 ? random_shuffle.this.result[0] : null
}

output "random_subset" {
  description = "Full shuffled result (first N if result_count set)"
  value       = random_shuffle.this.result
}

output "result_count" {
  description = "Number of items returned"
  value       = random_shuffle.this.result_count
}
