#### AWS Modules

This folder contains Terraform examples and modules targeting Amazon Web Services (AWS).

Important: Subfolders may include documentation-only READMEs (architecture notes, learning goals).
The actual Terraform implementation is always in the .tf files (main.tf, variables.tf, outputs.tf, providers.tf, etc.).
If you want to understand what gets deployed, inspect the Terraform files.

---

#### What’s inside

Typical examples in this AWS section may include:

- Networking (VPC, Subnets, IGW/NAT, Route Tables)
- Compute (EC2, Launch Templates, Autoscaling basics)
- Storage (S3, EBS)
- Identity & Access (IAM Users/Roles/Policies)
- Supporting services (Security Groups, CloudWatch basics, etc.)

---

#### Prerequisites

- Terraform v1.0+
- AWS Account
- AWS CLI installed
- Permissions to create the resources used in the examples

#### ecurity Notes

- Do not commit credentials (.aws/credentials, tokens, .tfvars containing secrets).
- Avoid putting access_key / secret_key into Terraform code.
- Prefer AWS CLI profiles, assume-role, and CI/CD secret stores for automation.

#### Configure the AWS CLI

Documentation: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html

#### Create an IAM User for Terraform (demo/testing)

Create a dedicated IAM user with programmatic access (Access Keys).

Allowed Policies (demo only):
 - AmazonEC2FullAccess
 - AmazonVPCFullAccess

⚠️ Production: follow least privilege and scope permissions to what your modules actually need.

#### Recommended: AWS CLI Profiles

For local development and testing, use AWS CLI named profiles instead of hardcoding keys or relying on one global environment configuration.

1) Create a dedicated Terraform profile

```shell
aws configure --profile terraform
```

You will be prompted for:

- AWS Access Key ID
- AWS Secret Access Key
- Default region (example: eu-central-1)
- Output format (example: json)

This creates/updates:

- Linux/macOS: ~/.aws/credentials and ~/.aws/config
- Windows: %USERPROFILE%\.aws\credentials and %USERPROFILE%\.aws\config

Example:
```shell
# ~/.aws/credentials
[terraform]
aws_access_key_id = AKIA...
aws_secret_access_key = ...
```
```shell
# ~/.aws/config
[profile terraform]
region = eu-central-1
output = json
```

2) Verify the profile works
```shell
aws sts get-caller-identity --profile terraform
```
If this returns your account/user/arn, you’re good.

Using the profile with Terraform

Set profile in the provider block
```shell
provider "aws" {
  profile = "terraform"
  region  = "eu-central-1"
}
```

#### Quick testing: Environment variables (not recommended long-term)

Terraform uses AWS CLI credentials for authentication.
At the beginning, it’s sufficient to use environment variables for testing.
Starting from Module 04, we’ll switch to using CLI profiles mentioned above for better security and maintainability.

Linux / macOS (Bash or Zsh)
```shell
export AWS_ACCESS_KEY_ID="<YOUR ACCESS KEY>"
export AWS_SECRET_ACCESS_KEY="<YOUR SECRET KEY>"
```
Windows PowerShell
```shell
PS C:\> $Env:AWS_ACCESS_KEY_ID="<YOUR ACCESS KEY>"
PS C:\> $Env:AWS_SECRET_ACCESS_KEY="<YOUR SECRET KEY>"
```
Windows Command Prompt (Permanent)
```shell
C:\> setx AWS_ACCESS_KEY_ID <YOUR ACCESS KEY>
C:\> setx AWS_SECRET_ACCESS_KEY <YOUR SECRET KEY>
```
Note: Environment variables are temporary unless made persistent in your shell profile (e.g., ~/.bashrc or PowerShell profile).

#### Not recommended: hardcoding credentials in Terraform

Although you can define credentials directly in a Terraform provider block, this is not recommended for security reasons.

```shell
provider "aws" {
  region     = "us-west-2"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}
```

Learn more: https://registry.terraform.io/providers/hashicorp/aws/latest/docs

### Basic Usage
1. Navigate to the desired deployment directory:

2. Initialize the Terraform working directory:
    -> terraform init

3. Preview and apply infrastructure changes:
    -> terraform plan
    -> terraform apply

4. Destroy resources that are no longer needed:
    -> terraform plan -destroy 
    -> terraform destroy   

5. ⚠️ Always verify that all resources have been properly destroyed or terminated to avoid unnecessary costs.
