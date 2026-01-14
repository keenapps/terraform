# ----------------------------
# Random ID for Unique Names
# ----------------------------
resource "random_id" "random" {
  byte_length = 4 # 4-byte random hex suffix (8 chars) for global unique names
}

resource "random_password" "vm_admin_pass" {
  count   = 4    # Generates 4 unique passwords for multiple VMs
  length  = 16   # 16-char length with letters, numbers, specials
  special = true # Includes special chars for security
}

resource "random_id" "vm_suffix" {
  count       = 4 # 4 VM-specific random suffixes
  byte_length = 4 # Per-VM unique hex ID (e.g. vm-${random_id.vm_suffix[0].hex})
}
