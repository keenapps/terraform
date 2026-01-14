# ----------------------------
# Resource Group - Persistent Storage (Data Lifecycle Separation)
# ----------------------------
resource "azurerm_resource_group" "terraform_res_storage" {
  name     = "terraform_storage" # Dedicated RG for storage (delete VMs ≠ data loss)
  location = "switzerlandnorth"  # Match VM region (latency)

  tags = {
    "Managed by"  = "Terraform"     # Governance tracking
    "Environment" = "Storage"       # Cost allocation
    "Purpose"     = "Hot/Cool Demo" # Business context
  }
}

# ----------------------------
# Storage Account - GPv2 + CMK Identity
# ----------------------------
resource "azurerm_storage_account" "tfstorage1" {
  name                     = "tfstorage1${random_id.random[0].hex}" # Globally unique (3-24 lowercase)
  resource_group_name      = azurerm_resource_group.terraform_res_storage.name
  location                 = azurerm_resource_group.terraform_res_storage.location
  account_tier             = "Standard" # GPv2 (blobs/files/tables/queues)
  account_replication_type = "LRS"      # Locally redundant (cheapest)
  access_tier              = "Hot"      # Default tier (blob override possible)
  large_file_share_enabled = true       # Premium Files support (>5TB)

  # CMK: User Assigned Identity (PDF: UMI for Storage → Key Vault access)
  identity {
    type         = "UserAssigned"                                           # Separate lifecycle from resource
    identity_ids = [azurerm_user_assigned_identity.storage_cmk_identity.id] # Binds UMI principal
  }

  tags = {
    "Managed by" = "Terraform"
    "encryption" = "CMK"                                      # Audit: Customer Managed Key
    "key_vault"  = azurerm_key_vault.terraform-key-vault.name # Traceability
    "hot_cool"   = "demo"                                     # Cost tracking
  }
}

# ----------------------------
# Private Blob Container - VM Data Isolation
# ----------------------------
resource "azurerm_storage_container" "tf-vm-app-data-share" {
  name                  = "terraform-vm-app-data" # Flat namespace (no /)
  storage_account_name  = azurerm_storage_account.tfstorage1.name
  container_access_type = "private" # MI/RBAC only (no public)

  metadata = {
    description = "Hot/Cool tier blobs for VM Cloud-Init download"
    accessed_by = "VM managed identities"
  }
}

# ----------------------------
# VM1 Blob - Hot Tier (High Availability/Frequent)
# ----------------------------
resource "azurerm_storage_blob" "vm1_hot" {
  name                   = "vm1-frequent-data.zip" # Matches compute cloudinit.tpl
  storage_account_name   = azurerm_storage_account.tfstorage1.name
  storage_container_name = azurerm_storage_container.tf-vm-app-data-share.name
  type                   = "Block"                                        # BlockBlob (append/parallel upload)
  source_content         = "Hot frequent data VM1: logs, metrics, config" # Inline content (TF generates)
  access_tier            = "Hot"                                          # Frequent access (higher cost)

  metadata = {
    vm_id        = "vm1"          # Lowercase (Azure rule)
    access_tier  = "hot"          # Tier override tracking
    purpose      = "logs-metrics" # Business context
    encrypted_by = "CMK"          # Compliance
  }
}

# ----------------------------
# VM2 Blob - Cool Tier (Infrequent/Archive)
# ----------------------------
resource "azurerm_storage_blob" "vm2_cool" {
  name                   = "vm2-archive-data.zip" # Matches compute cloudinit.tpl  
  storage_account_name   = azurerm_storage_account.tfstorage1.name
  storage_container_name = azurerm_storage_container.tf-vm-app-data-share.name
  type                   = "Block"
  source_content         = "Cool infrequent data VM2: backups, archives, snapshots"
  access_tier            = "Cool" # Cheaper (30+ days no access)

  metadata = {
    vm_id        = "vm2"
    access_tier  = "cool"
    purpose      = "backups-archives"
    encrypted_by = "CMK"
  }
}
