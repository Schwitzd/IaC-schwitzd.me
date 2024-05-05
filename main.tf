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

resource "github_actions_secret" "example_secret" {
  repository       = var.github_repo_name
  secret_name      = "AZURE_STATIC_WEB_APPS_API_TOKEN"
  plaintext_value  = azurerm_static_web_app.swa.api_key
}