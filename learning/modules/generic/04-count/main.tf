# ----------------------------
# Random ID Generator (Multiple Instances)
# ----------------------------
# Creates 3 random IDs (count = 3). Each instance can be referenced by index:
# random_id.random[0], random_id.random[1], random_id.random[2]
resource "random_id" "random" {
  byte_length = 8 # Length of the random value in bytes (8 bytes = 64-bit)
  count       = 3  # Number of random IDs to generate
}
# ----------------------------
# Output All Random IDs (Optional)
# ----------------------------
# Prints all generated random IDs as a list after apply.
output "random_ids_hex" {
  value = [for r in random_id.random : r.hex] # Collect all random_id hex values
}
