## Terraform Backend Example

This example demonstrates how to change and reconfigure a Terraform backend, using the HashiCorp Random provider as a lightweight test resource.

The purpose of this module is to understand how Terraform stores and manages state files when you switch from one backend type to another (e.g., local → remote).

## Overview

- Shows how to initialize Terraform with a custom backend
- Verifies backend configuration using a simple random string resource
- Useful for testing state file locations (e.g., local, s3, azurerm, gcs)

>💡 This example is purely for learning and testing.
>It does not deploy any real cloud infrastructure — only demonstrates backend handling.

To beginn, initialize the project by running `terraform init`.

Expected output:
>
>Initializing the backend...
>
>Successfully configured the backend "local"! Terraform will automatically use this backend unless the configuration changes.
>

This confirms that Terraform is properly initialized a new backend to store statefiles

## Notes

- Terraform uses a backend to store the state of your managed infrastructure.
- The backend defines where the state file lives and how Terraform locks or secures it.
- Changing a backend may require running the following command to migrate existing state data to the new location. 
```shell
terraform init -migrate-state
```
- This module is intended only for learning/testing backend configuration.
- It does not deploy production resources.
- Always back up your state file before changing backends.

You can easily replace the backend block with s3, azurerm, or gcs to test remote state storage.
