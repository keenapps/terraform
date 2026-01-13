# Deploying Multiple Linux VMs with Public IP in Azure using Terraform
This example demonstrates how to deploy two Azure Linux Virtual Machines with associated Public IP addresses, using the count meta-argument for iteration and random_id for unique VM naming.
​

It creates a complete network stack (Resource Group, VNet, Subnet) shared by both VMs, two Network Interfaces, two NICs with dynamic private IPs and static Public IP (for demonstration), SSH key authentication via tls_private_key, and outputs the instance IDs.
​

---

## Overview
This configuration demonstrates how to:

- Generate unique identifiers using random_id referenced in VM names for distinct resource identification.
​- Create two Linux VMs (azurerm_linux_virtual_machine with count = 2) using Ubuntu 24.04 LTS, Standard_D2s_v3 size, and SSH key auth (password disabled).
​- Provision two Network Interfaces (azurerm_network_interface with count = 2) attached to a shared subnet.
​- Allocate one static Public IP (azurerm_public_ip) which is associated to a NIC
​- Use tls_private_key to generate an SSH key pair injected into both VMs via admin_ssh_key.
​- Output a list of instance IDs for verification.
​
### Key Highlights

- Uses count.index for precise mapping: NIC → VM, NIC → VM, Random ID per instance in names.
​- Explicit depends_on on subnet for ordering; implicit dependencies via references.
​- SSH-only access (disable_password_authentication = true) for security; public key from generated TLS private key.
​- Shared VNet/Subnet (10.0.0.0/16, 10.0.2.0/24) for both VMs; scalable to more instances.
​- Outputs: instance_ids list showing both VM resource IDs post-deployment.
​
## What Changed Compared to the "Single VM" Version
Before (Single VM):
- Single NIC, no Public IP, no count iteration, password auth possible, static name "example-machine".
​- No random ID for uniqueness, no outputs list.

Now (Multiple VMs):
- count = 2 on NICs and VMs creates two instances dynamically.
​- VM names: example-machine${random_id.random[count.index].dec} for uniqueness (e.g., example-machine12345678).
​- SSH keys via tls_private_key.ssh_key (assumed defined); password auth disabled.
​- One Public IP allocated (extendable); tags on Public IP for governance.
​- Output changed to list: value = [for i in azurerm_linux_virtual_machine.example : i.id].
​
### Why Use random_id for Naming?

- Ensures unique VM names across runs/subscriptions without manual suffixes.
- random_id.random[count.index].dec provides a decimal string appended to names, preventing conflicts.
​- Keeps resources distinguishable while maintaining Terraform's declarative state.

### Public IP Handling:

- Allocates static Public IP (allocation_method = "Static") that persists across deallocations.
​- In code, one IP shown; for 1:1 per VM, add count = 2 and associate via NIC ip_configuration.public_ip_address_id. No separate association resource needed (unlike AWS EIP).
​

## Terraform Workflow

1. **Initialize the working directory**

2. **Review the planned infrastructure**

3. **Deploy the configuration**

4. **Verify deployment**
​
5. **In the Azure Dashboard (Region eg. switzerlandnorth):**

- 2 VM instances running
- 2 NIC's each attached to 1 VM
- Public IP allocated in each NIC's ip_configuration for per-VM attachment
- VM overview shows the Public IP as its public IPv4 address once associated via NIC

Proof of Concept
Verify two VMs, NICs, and network resources deployed successfully. 
1 VM example in Screenshot!
[instance deployed](./img/terraform1.png)
