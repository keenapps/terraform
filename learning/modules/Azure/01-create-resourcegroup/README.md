## This is an example of how to create an Azure Resource Group using Terraform.
This example demonstrates the basic Terraform workflow for creating an Azure Resource Group using the HashiCorp AzureRM provider.
​
Make sure to configure the correct Azure region and verify your Azure credentials, as resource names must be unique within the subscription. You can explore Azure regions, including options close to Germany like "Germany West Central", via the Azure portal.
​
To get started, initialize the project by running `terraform init`.

Expected output:
>
>Initializing the backend...
>Initializing provider plugins...
>- Finding latest version of hashicorp/azurerm ...
>Terraform has created a lock file .terraform.lock.hcl to record the provider
>selections it made above. Include this file in your version control repository
>so that Terraform can guarantee to make the same selections by default when
>you run "terraform init" in the future.
>
>Terraform has been successfully initialized!
>

This confirms that Terraform is properly initialized and has downloaded all required providers.

Next, create a plan to preview the infrastructure changes with: `terraform plan -out exampleplan`.

Expected output (shortend):

>Terraform will perform the following actions:
>
># azurerm_resource_group.terraform_test will be created
>  + resource "azurerm_resource_group" "terraform_test" {
>      + id       = (known after apply)
>      + location = "Switzerland North"
>      + name     = "terraform-test"
>      + tags     = {
>          + "Managed by" = "Terraform"
>        }
>    }
>

To actually apply the configuration execute `terraform apply testplan`.

Expected output:
> azurerm_resource_group.terraform_test: Creating...
> azurerm_resource_group.terraform_test: Still creating... [00m10s elapsed]
> azurerm_resource_group.terraform_test: Still creating... [00m20s elapsed]
> ...
>Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

The Resource Group is now provisioned in Azure.
​
You can check the result in the Azure Portal under Resource Groups.

If you modify any configuration values, rerun the plan and apply commands. Terraform previews changes before applying them.
​
Destroy the Resources
Finally, verify what will be destroyed with `terraform plan -destroy` and remove the environment using `terraform destroy`.
​
The Resource Group is then removed from Azure.
​
Confirmation appears in the Azure Portal with no Resource Group present.


Confirmation in EC2 Dashboard:
![instance deployed](./img/azure-res.png)