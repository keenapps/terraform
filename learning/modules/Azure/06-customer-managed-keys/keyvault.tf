# keyvault.tf - Complete RBAC-fixed version (CMK + SSH Secrets)

# Current Client Context
data "azurerm_client_config" "current" {}

# ----------------------------
# User Assigned Managed Identity - Storage CMK Proxy
# ----------------------------
resource "azurerm_user_assigned_identity" "storage_cmk_identity" {
  name                = "storage-cmk-identity"
  resource_group_name = azurerm_resource_group.terraform_res_VM.name
  location            = azurerm_resource_group.terraform_res_VM.location

  tags = {
    "Managed by" = "Terraform"
    "purpose"    = "storage-cmk-access"
  }
}

# ----------------------------
# Key Vault - SSH + CMK (Purge Protection, RBAC-ready)
# ----------------------------
resource "azurerm_key_vault" "terraform-key-vault" {
  name                = "tf-key-vault-${random_id.random[0].hex}"
  location            = azurerm_resource_group.terraform_res_VM.location
  resource_group_name = azurerm_resource_group.terraform_res_VM.name
  tenant_id           = data.azurerm_client_config.current.tenant_id

  sku_name = "standard"

  purge_protection_enabled   = true
  soft_delete_retention_days = 90

  # ADMIN POLICY ONLY (Terraform CLI/SP) - RBAC for UAI below
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = ["Get", "List", "Set", "Delete", "Purge", "Recover"]
    key_permissions = [
      "Get", "Create", "List", "Update", "Delete", "Purge", "Recover",
      "GetRotationPolicy", "SetRotationPolicy"
    ]
  }

  tags = {
    "Managed by" = "Terraform"
    "services"   = "ssh-secrets,storage-cmk"
    "compliance" = "purge-protection,rbac"
  }
}

# ----------------------------
# RBAC Role: Storage UAI Crypto Access
# ----------------------------
resource "azurerm_role_assignment" "storage_cmk_uai" {
  scope                = azurerm_key_vault.terraform-key-vault.id
  role_definition_name = "Key Vault Crypto Service Encryption User"
  principal_id         = azurerm_user_assigned_identity.storage_cmk_identity.principal_id

  depends_on = [
    azurerm_key_vault.terraform-key-vault,
    azurerm_user_assigned_identity.storage_cmk_identity
  ]
}

# ----------------------------
# SSH Key Secrets
# ----------------------------
resource "azurerm_key_vault_secret" "ssh_private_key" {
  name         = "ssh-private-key"
  value        = tls_private_key.ssh_key.private_key_pem
  key_vault_id = azurerm_key_vault.terraform-key-vault.id

  depends_on = [azurerm_key_vault.terraform-key-vault]
}

resource "azurerm_key_vault_secret" "ssh_public_key" {
  name         = "ssh-public-key"
  value        = tls_private_key.ssh_key.public_key_openssh
  key_vault_id = azurerm_key_vault.terraform-key-vault.id

  depends_on = [azurerm_key_vault.terraform-key-vault]
}

# ----------------------------
# CMK für Storage Encryption
# ----------------------------
resource "azurerm_key_vault_key" "storage_cmk" {
  name         = "storage-encryption-key"
  key_vault_id = azurerm_key_vault.terraform-key-vault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "unwrapKey",
    "wrapKey"
  ]

  depends_on = [azurerm_key_vault.terraform-key-vault]
}
