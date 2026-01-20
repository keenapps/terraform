# Azure Subnet Module

Creates an Azure Subnet within a VNET with optional service endpoints and delegation for services like AKS or SQL Managed Instance. Supports NSG association and private endpoint policies for secure networking.

# Usage Notes
Delegation enables services like "Microsoft.ContainerService/managedClusters" or "Microsoft.Sql/managedInstances"; set delegation_name to activate.
​
service_endpoints like ["Microsoft.Storage", "Microsoft.Sql"] optimize traffic without internet gateways.
​
nsg_id for association, private_endpoint_policy_disabled controls private endpoint policies ("Disabled"/"Enabled").
​
Attach NSG or route table separately post-creation.