locals {
  is_prod = terraform.workspace == "prod"
  custom_Dev_domains = local.is_prod ? "" : "test."
}
