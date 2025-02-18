# Define Variables
variable "project_name" {
  default = "myproject"
}

variable "environment" {
  default = "dev"
}

variable "location" {
  default = "East US"
}

variable "storage_account_tier" {
  default = "Standard"
}

variable "storage_account_replication" {
  default = "LRS"
}

variable "container_name" {
  default = "tfstate"
}
variable "subscription_id" {
  type = string
}

variable "client_id" {
  type = string
}
variable "client_secret" {
  type = string
}
variable "tenant_id" {
  type = string
}