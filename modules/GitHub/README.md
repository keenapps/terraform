#### GitHub Repository (Terraform)

This example demonstrates how to create a GitHub repository using the Terraform GitHub provider (integrations/github).

Important: The GitHub provider uses the GitHub API and therefore requires a Personal Access Token (PAT).
SSH keys are used for Git operations (clone/push), but not for provider authentication.

### What’s inside

Creates a private repository under the configured owner

Initializes the repo with a default README (auto_init = true)

Prerequisites

- Terraform v1.0+
- A GitHub account (user or org)
- A GitHub Personal Access Token (PAT)

### Security Notes

- Do not commit tokens (.tfvars, scripts, screenshots, logs).
- Prefer environment variables or CI/CD secret stores.
- Use short-lived tokens (expiration) and least privilege permissions.

### Create a GitHub Personal Access Token (PAT)

GitHub offers two token types. Fine-grained is recommended.

## Fine-grained token (recommended)

1. Go to: https://github.com/settings/personal-access-tokens/new

2. Set:
 - Token name (e.g. terraform)
 - Expiration (recommended)
 - Resource owner (your account or org)
 - Repository access: All repositories (or Only select repositories)

3. Repository permissions (minimum for creating repos):
 - Metadata: required
 - Administration: Read and write
 - Contents: Read and write

 4. Generate the token and copy it (you’ll only see it once).

## Store the token as an environment variable

Terraform (and the GitHub provider) will automatically use GITHUB_TOKEN.

Windows PowerShell (temporary)
 ```powershell
$Env:GITHUB_TOKEN="ghp_your_token_here"
 ```

Windows PowerShell (permanent)
 ```powershell
setx GITHUB_TOKEN "ghp_your_token_here"
 ```

Linux / macOS
 ```bash
export GITHUB_TOKEN="ghp_your_token_here"
 ```

Note: Environment variables are temporary unless added to your shell profile.

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

4. Destroy when finished:
```bash
terraform destroy
```