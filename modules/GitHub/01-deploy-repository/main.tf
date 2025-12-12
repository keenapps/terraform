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
  owner = "keenapps"
}

resource "github_repository" "terraform-repo" {
  name        = "terraform-deployed"
  description = "repository deployed with terraform"
  auto_init   = true
  visibility = "private"
}
