#Provision an Azure Synapse Workspace with Apache Spark Pool & SQL Pool

module "examplesyn01" {
  source                    = "../../"
  create_resource_group     = true
  resource_group_name       = "example-syn-rg"
  location                  = "centralindia"
  create_storage_account    = true
  storage_account_name      = "examplestor6754"
  data_lake_filesystem_name = "synfile01"
  sql_admin_username        = var.sql_admin_username
  sql_admin_password        = var.sql_admin_password
  synapse_workspace_name    = "example-synapse-01"
  managed_rg_name           = "example-synman-rg"
  identity_type             = "SystemAssigned"
  aad_admin = {
    login     = "user1@example.onmicrosoft.com"
    object_id = var.object_id
    tenant_id = var.tenant_id
  }

  create_spark_pool             = true
  spark_pool_name               = "examplespk01"
  enable_spark_dynamic_executor = true

  spark_autoscale_setting = {
    max_node_count = "6"
    min_node_count = "3"
  }

  create_sql_pool = true
  sql_pool_name   = "examplesql01"
  sql_pool_sku    = "DW100c"
  enable_tde      = true

  tags = {
    Application = "Synapse Workspace"
    Type        = "PaaS"
    Owner       = "Pranoy Bej"

  }
}