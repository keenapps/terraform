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
}

resource "azurerm_storage_container" "terraformstorage1_container" {
  name                  = "terraform-container"
  storage_account_name    = azurerm_storage_account.tfstorage1.name
  container_access_type = "private"
}

resource "azurerm_storage_blob" "example" {
  name                   = "my-awesome-content.zip"
  storage_account_name   = azurerm_storage_account.tfstorage1.name
  storage_container_name = azurerm_storage_container.terraformstorage1_container.name
  type                   = "Block"
  source_content         = "Demo blob from Terraform!"
}