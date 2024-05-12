variable "website_name" {
  type = string
}

variable "github_repo_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "resource_group_location" {
  type = string
}

variable "vault_address" {
  description = "The address of the HashiCorp Vault server"
  type        = string
}

variable "vault_token" {
  description = "The authentication token for accessing the HashiCorp Vault server"
  type        = string
  sensitive   = true
}