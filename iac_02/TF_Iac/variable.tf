# Define variables
variable "resource_group_name" {
  default = "secure-network-rg"
}

variable "location" {
  default = "East US"
}

variable "allowed_ips" {
  type    = list(string)
  default = ["203.0.113.1", "203.0.113.2"]  # Replace with your public IPs
}

variable "environment" {
  default = "dev"
}

variable "project_name" {
  default = "iac"
}

# Map for Virtual Network Address Spaces per Environment
variable "address_space_map" {
  type = map(string)
  default = {
    "dev"  = "10.0.0.0/16"
    "qa"   = "10.1.0.0/16"
    "prod" = "10.2.0.0/16"
  }
}

# Map for Subnet Address Prefixes per Environment
variable "address_prefixes_map" {
  type = map(map(string))
  default = {
    "dev" = {
      "frontend" = "10.0.1.0/24"
      "backend"  = "10.0.2.0/24"
      "database" = "10.0.3.0/24"
    }
    "qa" = {
      "frontend" = "10.1.1.0/24"
      "backend"  = "10.1.2.0/24"
      "database" = "10.1.3.0/24"
    }
    "prod" = {
      "frontend" = "10.2.1.0/24"
      "backend"  = "10.2.2.0/24"
      "database" = "10.2.3.0/24"
    }
  }
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