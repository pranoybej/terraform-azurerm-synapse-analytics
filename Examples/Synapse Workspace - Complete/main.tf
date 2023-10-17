#Provision an Azure Synapse Workspace with Spark Pool, SQL Pool and Integration Runtimes
#This example also showcase Firewall rules, Role-based-access-control, Audit Logging & Vulnerability Assessment


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

  synapse_firewall_rules = [
    {
      name     = "fwrule01"
      start_ip = "10.10.0.5"
      end_ip   = "10.10.0.6"
    },
    {
      name     = "fwrule02"
      start_ip = "20.10.0.7"
      end_ip   = "20.10.0.9"
    },
    {
      name     = "fwrule03"
      start_ip = "20.204.5.182"
      end_ip   = "20.204.5.182"
    }
  ]

  synapse_rbac_role_assignment = [
    {
      role_name    = "Synapse Artifact Publisher"
      principal_id = var.principal_id
    },
    {
      role_name    = "Synapse Credential User"
      principal_id = var.principal_id
    }
  ]

  synapse_ir = [
    {
      name             = "auto-ir-01"
      compute_type     = "MemoryOptimized"
      core_count       = "16"
      description      = "Memory Optimized Syanpse IR."
      time_to_live_min = "30"
    }
  ]

  synapse_managed_ir = [
    {
      name = "sh-ir-01"
    },
    {
      name = "sh-ir-02"
    }
  ]

  enable_synapse_workspace_alert = true
  email_addresses = [
    "email1@example.com",
    "email2@example.com"
  ]

  enable_auditing = true

  tags = {
    Application = "Synapse Workspace"
    Type        = "PaaS"
    Owner       = "Pranoy Bej"

  }
}