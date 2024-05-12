data "vault_generic_secret" "cloudflare" {
  path = "${local.vault_name}/cloudflare"
}