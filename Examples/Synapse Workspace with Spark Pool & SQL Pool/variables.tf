# The variables Section

variable "location" {
  type    = string
  default = "centralindia"
}

variable "rg_name" {
  type    = string
  default = "example-synapse-rg"
}

variable "object_id" {
  type      = string
  sensitive = true
  default   = ""
}

variable "tenant_id" {
  type      = string
  sensitive = true

}

variable "sql_admin_username" {
  type      = string
  sensitive = true
  default   = ""
}

variable "sql_admin_password" {
  type      = string
  sensitive = true
  default   = ""
}