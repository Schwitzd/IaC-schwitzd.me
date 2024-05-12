# Azure resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

# Azure static web app
resource "azurerm_static_web_app" "swa" {
  name                = local.swa_name
  resource_group_name = azurerm_resource_group.main.name
  location            = "westeurope"
  sku_tier            = "Free"
}

# Cloudflare DNS Record for root domain
resource "cloudflare_record" "root" {
  zone_id = data.vault_generic_secret.cloudflare.data["zone_id"]
  type    = "CNAME"
  name    = "@"
  value   = azurerm_static_web_app.swa.default_host_name
  proxied = true
}

# Cloudflare DNS Record for www subdomain
resource "cloudflare_record" "www" {
  zone_id = data.vault_generic_secret.cloudflare.data["zone_id"]
  type    = "CNAME"
  name    = local.www_website
  value   = azurerm_static_web_app.swa.default_host_name
  proxied = false
}

resource "time_sleep" "www-record" {
  depends_on = [cloudflare_record.www]

  create_duration = "3m"
}

# Azure custom www subdomain
resource "azurerm_static_web_app_custom_domain" "swa-www" {
  depends_on = [time_sleep.www-record]

  static_web_app_id = azurerm_static_web_app.swa.id
  domain_name       = local.www_website
  validation_type   = "cname-delegation"
}

# Azure custom root domain
resource "azurerm_static_web_app_custom_domain" "swa-root" {
  depends_on = [azurerm_static_web_app_custom_domain.swa-www]

  static_web_app_id = azurerm_static_web_app.swa.id
  domain_name       = var.website_name
  validation_type   = "dns-txt-token"
}

# Cloudflare DNS Record for root domain validation
resource "cloudflare_record" "root-txt" {
  zone_id = data.vault_generic_secret.cloudflare.data["zone_id"]
  type    = "TXT"
  name    = "@"
  value   = azurerm_static_web_app_custom_domain.swa-root.validation_token
}

# GitHub Action
resource "github_actions_secret" "example_secret" {
  repository      = var.github_repo_name
  secret_name     = "AZURE_STATIC_WEB_APPS_API_TOKEN"
  plaintext_value = azurerm_static_web_app.swa.api_key
}
