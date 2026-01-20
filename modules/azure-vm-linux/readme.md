# Azure Linux VM Module

Deploys one or multiple Linux Virtual Machines with flexible multi-instance support, custom images, identity, patching, and OS disk settings. Mirrors Windows counterpart for unified IaC across OS types, using random suffix for uniqueness.

# Usage Notes
Defaults require SSH public key via admin_ssh_key (not shown; add for production); admin_password supports password auth if disable_password_authentication=false.
​
patch_mode options: "AutomaticByPlatform", "ImageDefault", "Manual", "User"; identity "SystemAssigned" or "UserAssigned".
​
Multi-instance via instances map with overrides; single mode uses single_network_interface_ids.
​
custom_data for cloud-init scripts; extend with user_data base64 for advanced bootstrapping.