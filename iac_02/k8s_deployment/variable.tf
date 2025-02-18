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

variable "node_count" {
  default = 2
}

variable "vm_size" {
  default = "Standard_DS2_v2"
}

variable "mysql_admin_user" {
  default = "adminuser"
}

variable "mysql_admin_password" {
  default = "kRPLZB5ph!Zm"  
}
variable "namespace" {
  default = "backend"  
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
variable "ssh_key" {
  type = string
}
variable "sisense_build_node_label" {
}