# Azure Network Interface Module

Deploys an Azure Network Interface (NIC) with configurable private/public IP, static/dynamic allocation, and IPv4/IPv6 support. Essential for associating VMs with subnets and IPs in VNETs.

# Usage Notes

Auto-detects static allocation if private_ip_address provided; defaults to Dynamic.
​
public_ip_id=null creates private-only NIC; supports IPv6 via private_ip_version="IPv6".
​
Reference subnet_id from VNET/subnet module; attach to VM via network_interface_ids.