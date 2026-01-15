# ----------------------------
# Terraform Block - Provider Requirements
# ----------------------------
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm" # Official AzureRM provider from HashiCorp
      version = "~> 4.0"            # Allow any 4.x version (>= 4.0.0, < 5.0.0)
    }
  }
}

# Assign Storage Blob Data Reader to VMs
resource "azurerm_role_assignment" "vm_storage_reader" {
  count                = 2
  scope                = azurerm_storage_account.tfstorage1.id
  role_definition_name = "Storage Blob Data Reader"
  principal_id         = azurerm_linux_virtual_machine.example[count.index].identity[0].principal_id
}