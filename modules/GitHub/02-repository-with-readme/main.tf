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
  owner = "keenapps" #Your profile
}

resource "github_repository" "terraform_repo" {
  name        = "terraform-deployed"                 # Repository name
  description = "Repository deployed with Terraform" # Repository description
  auto_init   = true                                 # Initialize with first commit (README + default branch)
  visibility  = "private"                            # Repository visibility
}

resource "github_repository_file" "readme" {
  repository          = github_repository.terraform_repo.name                                      # Target repository
  branch              = "main"                                                                     # Branch to commit to
  file                = "README.md"                                                                # File path
  content             = "# Educational Repository\n\nThis repository is for educational purposes." # File content
  overwrite_on_create = true                                                                       # Overwrite if README already exists
}
