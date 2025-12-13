# ----------------------------
# Provider Block - GitHub Configuration
# ----------------------------
terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

# ----------------------------
# Configure the GitHub Provider
# ----------------------------
provider "github" {
  owner = "mygithub" #Your profile
}

resource "github_repository" "terraform_repo" {
  name        = "terraform-deployed"                 # Repository name
  description = "Repository deployed with Terraform" # Repository description
  auto_init   = true                                 # Initialize with first commit (README + default branch)
  visibility  = "private"                            # Repository visibility
}