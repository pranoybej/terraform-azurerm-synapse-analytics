# Declaring Locals for easier reference
locals {
  resource_group_name = element(coalescelist(data.azurerm_resource_group.erg.*.name, azurerm_resource_group.rg.*.name, [""]), 0)
  location            = element(coalescelist(data.azurerm_resource_group.erg.*.location, azurerm_resource_group.rg.*.location, [""]), 0)
  storage_name        = element(coalescelist(data.azurerm_storage_account.estr.*.name, azurerm_storage_account.str.*.name, [""]), 0)
  storage_id          = element(coalescelist(data.azurerm_storage_account.estr.*.id, azurerm_storage_account.str.*.id, [""]), 0)
  storage_ep          = element(coalescelist(data.azurerm_storage_account.estr.*.primary_blob_endpoint, azurerm_storage_account.str.*.primary_blob_endpoint, [""]), 0)
  storage_key         = element(coalescelist(data.azurerm_storage_account.estr.*.primary_access_key, azurerm_storage_account.str.*.primary_access_key, [""]), 0)
}

# Resource Group Creation or Selection
data "azurerm_resource_group" "erg" {
  count = var.create_resource_group == false ? 1 : 0
  name  = var.resource_group_name
}

resource "azurerm_resource_group" "rg" {
  count    = var.create_resource_group ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Storage Account Creation or Selection
data "azurerm_storage_account" "estr" {
  count               = var.create_storage_account == false ? 1 : 0
  name                = var.storage_account_name
  resource_group_name = local.resource_group_name
}

resource "azurerm_storage_account" "str" {
  count                    = var.create_storage_account ? 1 : 0
  name                     = var.storage_account_name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = var.storage_tier
  account_replication_type = var.storage_replication
  account_kind             = var.storage_kind
  access_tier              = var.stroage_access_tier
  is_hns_enabled           = var.enable_hns

  tags = var.tags
}

#Provision a Data Lake Gen2 File System within an Azure Storage Account
resource "azurerm_storage_data_lake_gen2_filesystem" "dlg2" {
  name               = var.data_lake_filesystem_name
  storage_account_id = local.storage_id
}

#Provision Azure Synapse Workspace
resource "azurerm_synapse_workspace" "syn" {
  name                                 = var.synapse_workspace_name
  resource_group_name                  = local.resource_group_name
  location                             = local.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.dlg2.id
  sql_administrator_login              = var.sql_admin_username
  sql_administrator_login_password     = var.sql_admin_password

  public_network_access_enabled        = var.public_network_access_enabled
  managed_virtual_network_enabled      = var.enable_managed_vnet
  data_exfiltration_protection_enabled = var.enable_managed_vnet && var.dep_enabled ? var.dep_enabled : false
  managed_resource_group_name          = var.managed_rg_name

  purview_id = var.purview_id
  aad_admin  = [var.aad_admin]

  dynamic "identity" {
    for_each = var.identity_type != null ? ["identity"] : []
    content {
      type         = var.identity_type
      identity_ids = var.identity_type == "UserAssigned" ? var.identity_ids : null
    }
  }

  tags = var.tags
}

#Provision an Apache Spark Pool within a synapse workspace
resource "azurerm_synapse_spark_pool" "spk" {
  count                = var.create_spark_pool ? 1 : 0
  name                 = var.spark_pool_name
  node_size_family     = var.spark_pool_family
  node_size            = var.spark_node_size
  synapse_workspace_id = azurerm_synapse_workspace.syn.id
  spark_version        = var.spark_version

  node_count                          = var.spark_autoscale_setting == null ? var.spark_node_count : null
  dynamic_executor_allocation_enabled = var.enable_spark_dynamic_executor
  min_executors                       = var.enable_spark_dynamic_executor ? var.min_spark_executor_size : null
  max_executors                       = var.enable_spark_dynamic_executor ? var.max_spark_executor_size : null

  auto_pause {
    delay_in_minutes = var.spark_pause_in_min
  }

  dynamic "auto_scale" {
    for_each = var.spark_autoscale_setting != null ? ["auto_scale"] : []
    content {
      max_node_count = var.spark_autoscale_setting.max_node_count
      min_node_count = var.spark_autoscale_setting.min_node_count
    }
  }

  dynamic "library_requirement" {
    for_each = var.spark_library_requirement != null ? ["library_requirement"] : []
    content {
      content  = var.spark_library_requirement.content
      filename = var.spark_library_requirement.filename
    }
  }

  dynamic "spark_config" {
    for_each = var.spark_config != null ? ["spark_config"] : []
    content {
      content  = var.spark_config.content
      filename = var.spark_config.filename
    }
  }

  tags = var.tags

}

#Provision a SQL Pool within a synapse workspace
resource "azurerm_synapse_sql_pool" "synsql" {
  count                = var.create_sql_pool ? 1 : 0
  name                 = var.sql_pool_name
  synapse_workspace_id = azurerm_synapse_workspace.syn.id
  sku_name             = var.sql_pool_sku

  create_mode = var.sql_pool_create_mode
  collation   = var.sql_pool_create_mode == "Default" ? var.sql_pool_collation : null

  data_encrypted            = var.enable_tde
  geo_backup_policy_enabled = var.enable_sql_pool_backups

  tags = var.tags

}

#Provision the Synapse Workspace Firewall rules
resource "azurerm_synapse_firewall_rule" "fwrules" {
  count                = (var.synapse_firewall_rules) != null ? length(var.synapse_firewall_rules) : 0
  synapse_workspace_id = azurerm_synapse_workspace.syn.id
  name                 = lookup(var.synapse_firewall_rules[count.index], "name", "firewall_rule")
  start_ip_address     = lookup(var.synapse_firewall_rules[count.index], "start_ip", "0.0.0.0")
  end_ip_address       = lookup(var.synapse_firewall_rules[count.index], "end_ip", "255.255.255.255")
}

#Assign RBAC roles in Synapse Analytics Workspace
resource "azurerm_synapse_role_assignment" "rbac_roles" {
  count                = var.synapse_rbac_role_assignment != null ? length(var.synapse_rbac_role_assignment) : 0
  synapse_workspace_id = azurerm_synapse_workspace.syn.id
  role_name            = lookup(var.synapse_rbac_role_assignment[count.index], "role_name")
  principal_id         = lookup(var.synapse_rbac_role_assignment[count.index], "principal_id")

  depends_on = [azurerm_synapse_firewall_rule.fwrules]
}

#Provision Azure Integration Runtime in Synapse Workspace
resource "azurerm_synapse_integration_runtime_azure" "syn_ir" {
  count                = var.synapse_ir != null ? length(var.synapse_ir) : 0
  name                 = lookup(var.synapse_ir[count.index], "name")
  synapse_workspace_id = azurerm_synapse_workspace.syn.id
  location             = local.location

  compute_type     = lookup(var.synapse_ir[count.index], "compute_type", "General")
  core_count       = lookup(var.synapse_ir[count.index], "core_count", "8")
  description      = lookup(var.synapse_ir[count.index], "description", "Azure Managed Synapse IR")
  time_to_live_min = lookup(var.synapse_ir[count.index], "time_to_live_min", "15")

}


#Provision Self-hosted Integration Runtime in Synapse Workspace
resource "azurerm_synapse_integration_runtime_self_hosted" "syn_sh_id" {
  count                = var.synapse_managed_ir != null ? length(var.synapse_managed_ir) : 0
  name                 = lookup(var.synapse_managed_ir[count.index], "name")
  synapse_workspace_id = azurerm_synapse_workspace.syn.id
}

#Provision a blob container within an Azure Storage Account for Synapse Workspace Vulnerability Alerts
resource "azurerm_storage_container" "workspace_container" {
  count                = var.enable_synapse_workspace_alert ? 1 : 0
  name                 = var.workspace_alert_container
  storage_account_name = local.storage_name
}

# Synapse Workspace Security Alert Policy
resource "azurerm_synapse_workspace_security_alert_policy" "syn_alrt" {
  count                      = var.enable_synapse_workspace_alert ? 1 : 0
  synapse_workspace_id       = azurerm_synapse_workspace.syn.id
  policy_state               = var.workspace_policy_state
  storage_endpoint           = local.storage_ep
  storage_account_access_key = local.storage_key

  disabled_alerts = var.workspace_disabled_alerts

  email_account_admins_enabled = var.email_account_admins_enabled
  email_addresses              = var.email_addresses

  retention_days = var.alert_retention_days
}

# Synapse Workspace Vulnerability Assessment
resource "azurerm_synapse_workspace_vulnerability_assessment" "syn_vuln" {
  count                              = var.enable_synapse_workspace_alert ? 1 : 0
  workspace_security_alert_policy_id = azurerm_synapse_workspace_security_alert_policy.syn_alrt[0].id
  storage_account_access_key         = local.storage_key
  storage_container_path             = "${local.storage_ep}${azurerm_storage_container.workspace_container[0].name}/"

  recurring_scans {
    enabled                           = var.enable_recurring_scans
    email_subscription_admins_enabled = var.email_account_admins_enabled
    emails                            = var.email_addresses
  }
}


#Configure audit logging for synapse workspace
resource "azurerm_synapse_workspace_extended_auditing_policy" "syn_adt" {
  count                      = var.enable_auditing ? 1 : 0
  synapse_workspace_id       = azurerm_synapse_workspace.syn.id
  storage_account_access_key = local.storage_key
  storage_endpoint           = local.storage_ep
  retention_in_days          = var.audit_log_retention_days
  log_monitoring_enabled     = var.log_monitoring_enabled
}