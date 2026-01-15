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

resource "azurerm_key_vault" "terraform-key-vault" {
  name                        = "tf-key-vault-${random_id.random[0].hex}"  # Global unique
  location                    = azurerm_resource_group.terraform_res_VM.location
  resource_group_name         = azurerm_resource_group.terraform_res_VM.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = false

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id  # User/SP

    secret_permissions = ["Get", "List", "Set", "Delete"]
  }

  tags = {
    "Managed by" = "Terraform"
  }
}

# Data Source für Tenant/Object ID (einmalig)
data "azurerm_client_config" "current" {}

# ----------------------------
# Key Vault Secrets
# ----------------------------
resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = "ssh-private-key"
  value        = tls_private_key.ssh_key.private_key_pem
  key_vault_id = azurerm_key_vault.terraform-key-vault.id
  depends_on   = [tls_private_key.ssh_key, azurerm_key_vault.terraform-key-vault]
}

resource "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "ssh-public-key"
  value        = tls_private_key.ssh_key.public_key_openssh
  key_vault_id = azurerm_key_vault.terraform-key-vault.id
  depends_on   = [tls_private_key.ssh_key, azurerm_key_vault.terraform-key-vault]
}