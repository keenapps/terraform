resource "random_id" "random" {
  byte_length = 4 # Length of the random value in bytes (4 bytes = 32-bit)
  count       = 2 # Number of random IDs to generate
}