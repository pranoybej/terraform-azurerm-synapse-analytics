## Synapse Workspace
Azure Synapse is an enterprise analytics service that accelerates time to insight across data warehouses and big data systems. Azure Synapse brings together the best of SQL technologies used in enterprise data warehousing, Spark technologies used for big data, Data Explorer for log and time series analytics, Pipelines for data integration and ETL/ELT, and deep integration with other Azure services such as Power BI, CosmosDB, and AzureML.

## Synapse Workspace Terraform Module
The Terraform module of Synapse Workspace supports creation of Azure Synapse Workspace. The module is resuable and can be used in any DevOps or CI/CD platform.

## Module Variables
The variables used in the module are given below. Please refer the `variables.tf` file for detailes variables description.

| Variable Name | Variable Type |
|------|---------|
| create_resource_group | Optional |
| resource_group_name | Required |
| location | Optional |
| create_storage_account | Optional | 
| storage_account_name | Required |
| storage_tier | Optional |
| storage_replication | Optional |
| storage_kind | Optional |
| stroage_access_tier | Optional |
| enable_hns | Optional | 
| data_lake_filesystem_name | Optional |
| synapse_workspace_name | Required |
| sql_admin_username | Required |
| sql_admin_password | Required |
| public_network_access_enabled | Optional |
| enable_managed_vnet | Optional |
| dep_enabled | Optional |
| identity_type | Optional |
| identity_ids | Optional |
| managed_rg_name | Required |
| purview_id | Optional |
| aad_admin | Required |
| create_spark_pool | Optional |
| spark_pool_name | Optional |
| spark_pool_family | Optional |
| spark_node_size | Optional |
| spark_version | Optional |
| spark_node_count | Optional |
| spark_pause_in_min | Optional |
| enable_spark_dynamic_executor | Optional |
| min_spark_executor_size | Optional |
| max_spark_executor_size | Optional |
| spark_autoscale_setting | Optional |
| spark_library_requirement | Optional |
| spark_config | Optional |
| create_sql_pool | Optional |
| sql_pool_name | Optional |
| sql_pool_sku | Optional |
| sql_pool_create_mode | Optional |
| sql_pool_collation | Optional |
| enable_tde | Optional |
| enable_sql_pool_backups | Optional |
| synapse_firewall_rules | Optional |
| synapse_rbac_role_assignment | Optional |
| synapse_ir | Optional |
| synapse_managed_ir | Optional |
| workspace_alert_container | Optional |
| enable_synapse_workspace_alert | Optional |
| workspace_policy_state | Optional |
| workspace_disabled_alerts | Optional |
| email_account_admins_enabled | Optional |
| email_addresses | Optional |
| alert_retention_days | Optional |
| enable_recurring_scans | Optional |
| enable_auditing | Optional |
| audit_log_retention_days | Optional |
| log_monitoring_enabled | Optional |
| tags | Optional |

## Module Usage
This module can be used to create an Azure Synapse Workspace. Optionaly, you can create a Spark Pool, Dedicated SQL Pool, Firewall rules, Audit Loggin, Alert Manged IR, Self-Hosted IR within the Synapse Workspace using this module. 

Some valid use cases are:

- Azure Syanpse Workspace
- Azure Syanpse Workspace with firewall rules
- Azure Syanpse Workspace with a Spark Pool 
- Azure Syanpse Workspace with a Spark Pool & dedicated SQL Pool
- Azure Syanpse Workspace with firewall rules, spark pool and sql pool
- Azure Synapse Workspace with managed Integration Runtime
- Azure Synapse Workspace with Self-hosted Integration Runtime
- Azure Synapse Workspace with managed & Self-hosted Integration Runtime
- Azure Synapse Workspace with a Spark Pool, dedicated SQL Pool and Audit Logging
- Azure Synapse Workspace with a firewall rules, Managed IR, Self-Hosted IR, Spark Pool, dedicated SQL Pool, Audit Logging and Vulnerability Assessment


Please see the below listed example:

```terraform

# Azurerm provider configuration
provider "azurerm" {
  features {}
}

#Provision an Azure Synapse Workspace with managed & self-hosted integration runtimes
#The example also creates an Apache Spark Pool
#The example also shows syanpse workspace role assignment
#This example also enables synapse workspace audit logging, vulnerabiltiy assessment & alert
module "synapse01" {
  source                    = "./Synapse Workspace"
  create_resource_group     = true
  resource_group_name       = "pb-syn-rg"
  location                  = "centralindia"
  create_storage_account    = true
  storage_account_name      = "pbstor6754"
  data_lake_filesystem_name = "synfile01"
  sql_admin_username        = "pbsqadm1n"
  sql_admin_password        = "p124fgd3edg4!#w26thg!"
  synapse_workspace_name    = "pb-synapse-01"
  managed_rg_name           = "pb-synman-rg"
  identity_type             = "SystemAssigned"
  aad_admin = {
    login     = "pranoy.bej@cogcis.onmicrosoft.com"
    object_id = "a9de337a-9fc9-4011-bb6d-01c6845136af"
    tenant_id = "188285f7-8f1e-4c0d-a0bc-797e3e38c5b3"
  }

  create_spark_pool             = true
  spark_pool_name               = "pbspk01"
  enable_spark_dynamic_executor = true

  spark_autoscale_setting = {
    max_node_count = "6"
    min_node_count = "3"
  }

  create_sql_pool = true
  sql_pool_name   = "pbsql01"
  sql_pool_sku    = "DW300c"
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
      name     = "pbrule01"
      start_ip = "20.204.5.182"
      end_ip   = "20.204.5.182"
    }
  ]

  synapse_rbac_role_assignment = [
    {
      role_name    = "Synapse Artifact Publisher"
      principal_id = "a9de337a-9fc9-4011-bb6d-01c6845136af"
    },
    {
      role_name    = "Synapse Credential User"
      principal_id = "a9de337a-9fc9-4011-bb6d-01c6845136af"
    }
  ]

  synapse_ir = [
    {
      name             = "pb-ir-01"
      compute_type     = "MemoryOptimized"
      core_count       = "16"
      description      = "Memory Optimized Syanpse IR."
      time_to_live_min = "30"
    }
  ]

  synapse_managed_ir = [
    {
      name = "pb-sh-ir-01"
    },
    {
      name = "pb-sh-ir-02"
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
    Owner       = "Terraform SWAT"

  }
}


```

## Module Output
This module exports the following attributes

- `rg_id`                       - The ID of the provisioned communication service.
- `str_id`                      - The ID of the provisioned storage account.
- `dlg2_id`                     - The ID of the newly created Data Lake Gen2 file system.
- `syn_id`                      - The ID of the newly created synapse Workspace.
- `syn_cep`                     - A list of Connectivity endpoints for this Synapse Workspace.
- `spk_id`                      - The ID of the newly created Synapse Spark Pool.
- `sql_pool_id`                 - The ID of the newly created Synapse Spark Pool.
- `sh_ir_id`                    - The ID of the Synapse Self-hosted Integration Runtime.
- `sh_ir_pkey`                  - The ID of the Synapse Self-hosted Integration Runtime.
- `sh_ir_skey`                  - The ID of the Synapse Self-hosted Integration Runtime.
- `wksp_alrt_cntnr_name`        - The name of the blob contianer where vulnerability scan results are stored.
- `wksp_alrt_plcy_id`           - The ID of the Synapse Workspace Security Alert Policy.
- `wksp_vuln_asmnt_id`          - The ID of the Synapse Workspace Vulnerability Assessment.
- `syn_adt_id`                  - The ID of the Synapse Workspace Extended Auditing Policy.