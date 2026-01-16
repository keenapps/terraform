resource "random_pet" "this" {
  prefix    = var.prefix
  length    = var.length
  separator = var.separator
  keepers   = var.keepers
}