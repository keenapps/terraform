resource "random_password" "this" {
  length           = var.length
  special          = var.special
  override_special = var.override_special
  min_lower        = var.min_lower
  min_upper        = var.min_upper
  min_numeric      = var.min_numeric
  min_special      = var.min_special

  keepers = {
    rotation_trigger = var.rotation_trigger # Custom trigger (e.g., timestamp(), env)
  }
}
