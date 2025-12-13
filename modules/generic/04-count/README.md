## Demonstration of Using random_id with count and Outputs in Terraform

This example extends the basic Terraform workflow by showcasing how to use the HashiCorp Random Provider to generate multiple unique identifiers using the random_id resource with count.

In this case, we generate 3 random IDs (count = 3) with a size of 8 bytes (byte_length = 8) and print them using Terraform outputs.

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

random_ids_hex = [
  "3bb9d34466bbfe21",
  "c27cffe1fd1d739a",
  "af23a0a6b56e54a5",
]
```

5. Destroy when finished:
```bash
terraform destroy
```

## Why This Is Useful

The random_id resource is particularly useful for generating unique identifiers for naming resources such as storage buckets, objects, or virtual machines where a random suffix helps avoid naming collisions.