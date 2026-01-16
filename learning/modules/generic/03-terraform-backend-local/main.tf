# ----------------------------
# Provider Block - GitHub Configuration
# ----------------------------
terraform { # Resource Block to set a local directory for terraform state files
  backend "local" {
    path = "./backend/terraform.tfstate"
  }
}