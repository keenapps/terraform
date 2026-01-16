# ----------------------------
# Resource Group - Logical Container for Azure Resources
# ----------------------------
resource "azurerm_resource_group" "terraform_res_storage" {
  name     = "terraform_storage"
  location = "switzerlandnorth"

  tags = {                     # Tags for governance/cost tracking/ownership
    "Managed by" = "Terraform" # Marks that Terraform manages this resource
  }
}

resource "azurerm_storage_account" "tfstorage1" {
  name                     = "tfstorage1${random_id.random[0].dec}"
  resource_group_name      = azurerm_resource_group.terraform_res_storage.name
  location                 = azurerm_resource_group.terraform_res_storage.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  large_file_share_enabled = true
  access_tier              = "Hot"
  tags = {
    "Managed by"  = "Terraform"
    "Environment" = "Storage"
  }
}

resource "azurerm_storage_container" "tf-vm-app-data-share" {
  name                  = "terraform-vm-app-data"
  storage_account_name  = azurerm_storage_account.tfstorage1.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "vm1_hot" {
  name                   = "vm1-frequent-data.zip"
  storage_account_name   = azurerm_storage_account.tfstorage1.name
  storage_container_name = azurerm_storage_container.tf-vm-app-data-share.name
  type                   = "Block"
  source_content         = "Hot data for VM1 (logs/metrics)"
  access_tier            = "Hot" # Explicit (inherits anyway)
}

resource "azurerm_storage_blob" "vm2_cool" {
  name                   = "vm2-archive-data.zip"
  storage_account_name   = azurerm_storage_account.tfstorage1.name
  storage_container_name = azurerm_storage_container.tf-vm-app-data-share.name
  type                   = "Block"
  source_content         = "Cool data for VM2 (backups/archives)"
  access_tier            = "Cool" # Per-blob override (cheaper storage)
}