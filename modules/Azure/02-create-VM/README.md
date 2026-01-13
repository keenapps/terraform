# Deploying a Linux VM with VNet in Azure using Terraform

This example demonstrates how to use Terraform to provision a complete Azure environment consisting of a Resource Group, Virtual Network, Subnet, Network Interface, and a Linux Virtual Machine.

The configuration leverages the AzureRM provider (version 4.x) and uses an Ubuntu 24.04 LTS image from Canonical as the source for the virtual machine.

---

## Overview

This configuration illustrates how to:

- Create an Azure Resource Group as a logical container for all resources. 
- Deploy a Virtual Network (VNet) and Subnet to define an isolated address space.
- Provision a Network Interface (NIC) and attach it to the subnet. 
- Launch an Azure Linux Virtual Machine connected to the NIC, using a managed OS disk and a Canonical Ubuntu image.  

### Key Highlights

- Uses a version constraint `~> 4.0` in the provider block to allow any compatible 4.x AzureRM provider release.
- Reuses the Resource Group location for VNet, NIC, and VM to keep all resources in the same Azure region (switzerlandnorth).

---

## Terraform Configuration Structure

The Terraform configuration is logically split into several resource blocks, each representing a specific Azure resource.

- **Provider configuration**  
  - Specifies the `azurerm` provider with a 4.x version constraint and enables it as the primary interface to Azure Resource Manager.

- **Resource Group**  
  - `azurerm_resource_group` defines a named container (`terraform_test`) in a given Azure region (`switzerlandnorth`) and applies tags for governance such as `"Managed by" = "Terraform"".

- **Virtual Network (VNet)**  
  - `azurerm_virtual_network` creates a private network (`terraform-network`) with address space `10.0.0.0/16`, which acts similarly to a VPC in other clouds.

- **Subnet**  
  - `azurerm_subnet` creates a subnet named `internal` within the VNet, using the address range `10.0.2.0/24` that must be contained within the VNet's address space. 

- **Network Interface (NIC)**  
  - `azurerm_network_interface` provisions a NIC (`terraform-nic`) in the Resource Group and region, wiring it to the subnet with a dynamically assigned private IP.

- **Linux Virtual Machine**  
  - `azurerm_linux_virtual_machine` defines the compute instance:  
    - Uses size `Standard_D2s_v3` to specify CPU/RAM.  
    - Sets `admin_username` and `admin_password` for local login (though passwords in code are discouraged for production).  
    - Attaches the previously created NIC via `network_interface_ids`.  
    - Configures an OS disk with `Standard_LRS` storage and `ReadWrite` caching.  
    - Uses a Canonical Ubuntu `ubuntu-24_04-lts` offer with `sku = "server"` and `version = "latest"".

---

## Terraform Workflow

This section describes the end-to-end Terraform workflow for this configuration.

1. **Initialize the working directory**

   - Ensure the configuration files (provider.tf, ssh.tf, main.tf) are present in the project directory.  
   - Run:  
     ```bash
     terraform init
     ```  
   - This command downloads the AzureRM provider plugin and creates the `.terraform.lock.hcl` file to pin provider versions.

2. **Review the planned infrastructure**

   - Execute:  
     ```bash
     terraform plan -out main.tfplan
     ```  
   - Terraform shows a plan similar to:  
     - 1 Resource Group to add.  
     - 1 Virtual Network to add.  
     - 1 Subnet to add.  
     - 1 Network Interface to add.  
     - 1 Linux Virtual Machine to add.

3. **Deploy the configuration**

   - Apply the execution plan:  
     ```bash
     terraform apply "main.tfplan"
     ```  
   - Terraform creates the resources in Azure, and you should see output indicating each resource being created and an `Apply complete!` message. 

4. **Verify deployment**

   - In the Azure Portal, navigate to:  
     - **Resource Groups** → `terraform_test` to confirm the Resource Group and all nested resources exist.  
     - **Virtual networks** to verify `terraform-network` and the `internal` subnet.  
     - **Virtual machines** to confirm that the Linux VM `example-machine` is running in the expected region.

---

## Managing Desired State Changes

Terraform manages infrastructure as **desired state**, so changes to configuration lead to incremental updates on Azure resources.

- **Changing VM size**  
  - If you change the `size` argument of `azurerm_linux_virtual_machine` (from `Standard_D2s_v3` to another VM SKU), Terraform will show whether the change is in-place or requires recreation, depending on Azure capabilities for that VM type.

- **Example plan output for a size change**

  When running `terraform plan` after modifying the `size` field, you might see output that includes a `~` symbol indicating an in-place update on the VM resource:

  > Resource actions are indicated with the following symbols:  
  >  ~ update in-place  
  >  
  > Terraform will perform the following actions:  
  >  
  >   # azurerm_linux_virtual_machine.example will be updated in-place  
  >   ~ resource "azurerm_linux_virtual_machine" "example" {  
  >       id   = "/subscriptions/.../resourceGroups/terraform_test/providers/Microsoft.Compute/virtualMachines/example-machine"  
  >     ~ size = "Standard_D2s_v3" -> "Standard_D4s_v3"  
  >     ...

  This indicates that Terraform will adjust the VM size without destroying and recreating the entire resource (subject to Azure restrictions). 

- **Apply the updated plan**

  - After reviewing, run:  
    ```bash
    terraform apply
    ```  
  - Terraform updates the resources so that the real infrastructure matches the new desired configuration. 

---

## Clean Up Resources

To avoid ongoing costs and return Azure to its original state, destroy all resources that were created.

- Preview the destruction (optional):  
  ```bash
  terraform plan -destroy -out destroy.tfplan
  ```  
This shows that the Resource Group, VNet, Subnet, NIC, and Linux VM will all be removed.

Execute the destroy:

  ```bash
    terraform destroy
  ```  
Confirm with yes when prompted; Terraform will delete all managed resources and print Destroy complete!.

You can then verify in the Azure Portal that the terraform_test Resource Group and its contents are no longer present.