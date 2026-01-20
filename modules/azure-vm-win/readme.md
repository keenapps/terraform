# Azure Windows VM Module

Deploys one or multiple Windows Virtual Machines with flexible sizing, image selection, identity, patching, and OS disk configuration. Supports single VM or multi-instance maps for scalable IaC, integrating random suffix for unique naming.

# Usage Notes
Defaults to Windows Server 2022 Datacenter Core; override image_* for other SKUs like "2022-datacenter-azure-edition".
​
Multi-VM via instances map; falls back to single with single_network_interface_ids if empty.
​
Sensitive admin_password handling and optional password auth disable supported.
​
Patch modes include "AutomaticByPlatform"; identity defaults to SystemAssigned.