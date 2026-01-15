## Demonstration of Using random_password with keepers and Outputs in Terraform

This example shows how to use the HashiCorp Random Provider to generate a secure password with the random_password resource and export it via Terraform outputs.

It also demonstrates the keepers mechanism: an arbitrary map stored in Terraform state that forces regeneration of the password when any value inside keepers changes. In this setup we use timestamp() so the password is regenerated on every apply.

## Basic Usage

1. Enter your GitHub Username in the Providerblbock

2. Initialize Terraform:
```bash
terraform init
```

3. Plan and apply:
```bash
terraform plan
terraform apply
```

4. Verify Result
Example Output in Terraform CLI:
```bash
Outputs:

password = <sensitive>
```
Check the changing password after a new terraform apply in the statefile.

5. Destroy when finished:
```bash
terraform destroy
```

## Why This Is Useful

- Secure secrets generation: Create strong random passwords for databases, apps, or service accounts.
- Controlled rotation with keepers: Terraform will recreate (rotate) the password when keepers changes.
  - With timestamp() as shown, it rotates every apply.
  - In real setups, you often tie keepers to something meaningful (e.g., username, environment, instance ID) so it rotates only when needed.
- Safer CLI output: Marking the output as sensitive prevents Terraform from printing the secret by default.

⚠️ Note: Even if an output is sensitive, the generated password is still stored in the Terraform state file. Protect your state (remote backend, encryption, restricted access).