# Azure Resource Group Module

Creates an Azure Resource Group with standardized tags for environment tracking and Terraform management. Serves as a foundational container for all Azure resources in IaC deployments.

# Usage Notes

Location sets the default region for resources in the group; choose based on compliance like "Switzerland North".
​
Auto-adds Environment and ManagedBy=Terraform tags for governance; merge custom tags.
​
Essential first resource in Terraform configurations for scoping deployments.