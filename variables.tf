variable "subscription_id" {
  description = "Azure Subscription ID for your account"
  type        = string
}

variable "client_id" {
  description = "Client ID for the Service Portal"
  type        = string
}

variable "client_secret" {
  description = "Azure Client Secret for Service Principal"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}
