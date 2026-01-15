# ----------------------------
# Terraform Block - Provider Requirements (Root Module)
# ----------------------------
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Official Azure Resource Manager provider
      version = "~> 4.0"            # Lock: >=4.0.0 <5.0.0 (patch/minor updates)
    }
  }
}

# ----------------------------
# RBAC Role Assignment - VM System Identity → Storage Blob Reader
# ----------------------------
resource "azurerm_role_assignment" "vm_storage_reader" {
  count                = 2                                     # Matches VM count (VM0 + VM1)
  scope                = azurerm_storage_account.tfstorage1.id # Narrow: Storage Account only (not RG)
  role_definition_name = "Storage Blob Data Reader"            # Exact Azure built-in role name

  # VM[count.index].identity[0].principal_id = Entra ID Object ID
  # VM[n] → system-assigned identity → principal_id → RBAC principal
  principal_id = azurerm_linux_virtual_machine.example[count.index].identity[0].principal_id
}
