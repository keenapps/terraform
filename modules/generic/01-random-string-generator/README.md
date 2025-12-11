## This is an example of the basic functions of Terraform using the Hashicorp Random String Generator.

This example demonstrates the fundamental Terraform workflow using the HashiCorp Random String Generator provider.

To beginn, initialize the project by running `terraform init`.

Expected output:
>
>Initializing the backend...
>Initializing provider plugins...
>- Finding latest version of hashicorp/random...
>Terraform has created a lock file .terraform.lock.hcl to record the provider
>selections it made above. Include this file in your version control repository
>so that Terraform can guarantee to make the same selections by default when
>you run "terraform init" in the future.
>
>Terraform has been successfully initialized!
>

This confirms that Terraform is properly initialized and has downloaded all required providers.

Next, create a plan to preview the infrastructure changes with: `terraform plan`.

Expected output:
>  # random_string.random will be created
>  + resource "random_string" "random" {
>      + id          = (known after apply)
>      + length      = 16
>      + lower       = true
>      + min_lower   = 0
>      + min_numeric = 0
>      + min_special = 0
>      + min_upper   = 0
>      + number      = true
>      + numeric     = true
>      + result      = (known after apply)
>      + special     = true
>      + upper       = true
>    }
>

To actually apply the configuration, first save the plan: `terraform plan -out exampleplan`,
Then apply it with: `terraform apply exampleplan`.

Expected output:
>
>random_string.random: Creating...
>random_string.random: Creation complete after 0s [id=-y:]U2[S!3zz}s(u]
>
>Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
>

If you modify any configuration values, you can rerun the plan and apply commands. Terraform will show a detailed preview of the changes before applying them, for example: `terraform plan exampleplan`

>Terraform will perform the following actions:
>
>  # random_string.random must be replaced
>-/+ resource "random_string" "random" {
>      ~ id          = "-y:]U2[S!3zz}s(u" -> (known after apply)
>      ~ length      = 16 -> 20 # forces replacement
>      ~ result      = "-y:]U2[S!3zz}s(u" -> (known after apply)
>        # (9 unchanged attributes hidden)
>    }
>
>Plan: 1 to add, 0 to change, 1 to destroy.
>
If you wish you can go on and use terraform apply to change the string.

Once you are finished, you can verify what will be destroyed with: `terraform plan -destroy` And remove the environment entirely using: `terraform destroy`.