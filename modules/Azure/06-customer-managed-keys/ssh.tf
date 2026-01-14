# ----------------------------
# Generate SSH Key Pair
# ----------------------------
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA" # RSA algorithm (ECDSA/ED25519 also supported)
  rsa_bits  = 4096  # Strong 4096-bit key size (security best practice)
}

# ----------------------------
# Save Private Key Locally (optional)
# ----------------------------
resource "local_file" "private_key" {
  content         = tls_private_key.ssh_key.private_key_pem # Generated private key in PEM format
  filename        = "${path.module}/id_rsa"                 # Saves to terraform working directory
  file_permission = "0600"                                  # Owner read/write only
}