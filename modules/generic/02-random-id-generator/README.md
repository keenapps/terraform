## Demonstration of Using Different Random Generators in Terraform

This example extends the basic Terraform workflow by showcasing how to use different random resource types provided by the HashiCorp Random Provider.

In this case, we demonstrate the use of the random_id resource to generate a random, unique identifier.

To begin, initialize the project with:
```bash
terraform init
```

After initialization, create a plan to preview the infrastructure actions:
```bash
terraform plan
```

Take note that in this example to plan will differ accordingly to the string generator.
When you are finished reviewing the plan follow up with:
```bash
terraform apply
```

Example Output:
```bash
random_id.random: Creation complete after 0s [id=mQegLRthBczClSRyNfI5UA]
```

The random_id resource is particularly useful for generating unique identifiers for naming resources such as storage buckets, S3 objects, or virtual machines, where a random suffix ensures uniqueness.

To remove the generated identifier and clean up the environment, run:
```bash
terraform destroy
```