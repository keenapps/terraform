# ----------------------------
# Random Password Generator
# ----------------------------
resource "random_password" "password" {
  length           = 16                     # Total password length (number of characters)
  special          = true                   # Include special characters in the generated password
  override_special = "!#$%&*()-_=+[]{}<>:?" # Restrict which special characters are allowed

  # keepers is an arbitrary map Terraform stores in state for this resource.
  # If ANY value in this map changes, Terraform will "replace" this resource
  # and generate a NEW password.
  keepers = {
    triggers = timestamp() # timestamp() changes every plan/apply -> forces password regeneration every run
    # "triggers" is just a custom key name (not a special Terraform keyword)
  }
}

# ----------------------------
# Output Password
# ----------------------------
output "password" {
  value     = random_password.password.result # Expose the generated password value
  sensitive = true                            # Hide the output in CLI logs (still stored in state!)
}