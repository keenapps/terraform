# Azure Storage Account Module

Provisions a secure Azure Storage Account optimized for logging and blobs with private access by default. Supports configurable tier, replication, kind, and network restrictions for cost-effective IaC deployments.

# Usage Notes

Name must be globally unique, 3-24 lowercase alphanumeric characters.
​
Defaults to Standard_LRS StorageV2 for cost-optimized logging; LRS suits non-critical logs.
​
public_network_access_enabled=false and allow_nested_items_to_be_public=false enforce private access.
​
Extend with containers, queues, or private endpoints for production.
​