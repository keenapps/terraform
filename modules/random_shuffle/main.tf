resource "random_shuffle" "this" {
  list         = var.input_list
  result_count = var.result_count
  keepers      = var.keepers
}
