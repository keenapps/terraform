# ----------------------------
# Provider Block - Random Number Generator
# ----------------------------
resource "random_id" "random" {
  byte_length = 2
}

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