locals {
  swa_name    = replace(var.website_name, ".", "-")
  www_website = "www.${var.website_name}"
  vault_name  = "iac-${var.website_name}"
}
