## This is an example of the basic functions of Terraform using the Hashicorp Random String Generator.

To start type `terraform init` inside this directory.

The Result should be:
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

This will prove that terraform is in fact initialized and downloaded all necessary plugins.
You are now ready to start planning the actually provision with `terraform plan`.

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

However to actually apply the plan you need to save the plan with `terraform plan -out exampleplan`,
and execute the code with `terraform apply`.

Example Output:
>
>random_string.random: Creating...
>random_string.random: Creation complete after 0s [id=-y:]U2[S!3zz}s(u]
>
>Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
>