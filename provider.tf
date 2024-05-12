terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0, < 2.0.0"
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

provider "github" {}

provider "cloudflare" {
  api_token = data.vault_generic_secret.cloudflare.data["api_token"]
}

provider "time" {}

provider "vault" {
  address          = var.vault_address
  token            = var.vault_token
  skip_child_token = true
}
