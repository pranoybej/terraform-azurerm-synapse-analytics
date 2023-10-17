#The variables section of Synapse Workspace Module

variable "create_resource_group" {
  type        = bool
  description = "(Optional) Do you have a Resource Group or want to create a new one ?"
  default     = false
}

variable "resource_group_name" {
  description = "(Required) The name of an existing resource group to be imported."
  type        = string
}

variable "location" {
  type        = string
  description = "(Optional) The Azure Region where the Synapse Workspace should exist."
  default     = ""
}

variable "create_storage_account" {
  type        = bool
  description = "(Optional) Do you have a Storage Account or want to create a new one ?"
  default     = false
}

variable "storage_account_name" {
  type        = string
  description = "(Required) Specifies the name of the storage account. Only lowercase Alphanumeric characters allowed."
}

variable "storage_tier" {
  type        = string
  description = "(Optional) Defines the Tier to use for this storage account."
  default     = "Standard"
}

variable "storage_replication" {
  type        = string
  description = " (Optional) Defines the type of replication to use for this storage account."
  default     = "LRS"
}

variable "storage_kind" {
  type        = string
  description = "(Optional) Defines the access tier for this storage acccount."
  default     = "StorageV2"
}

variable "stroage_access_tier" {
  type        = string
  description = "(Optional) Defines the access tier for the Stroage Account."
  default     = "Hot"
}

variable "enable_hns" {
  type        = bool
  description = "(Optional) Is Hierarchical Namespace enabled? This can be used with Azure Data Lake Storage Gen 2."
  default     = true
}

variable "data_lake_filesystem_name" {
  type        = string
  description = "(Optional) The name of the Data Lake Gen2 File System which should be created within the Storage Account"
  default     = ""
}

variable "synapse_workspace_name" {
  type        = string
  description = "(Required) Specifies the name which should be used for this synapse Workspace."
}

variable "sql_admin_username" {
  type        = string
  description = "(Required) Specifies The login name of the SQL administrator."
  sensitive   = true
}

variable "sql_admin_password" {
  type        = string
  description = "(Required) The Password associated with the SQL administrator."
  sensitive   = true
}

variable "public_network_access_enabled" {
  type        = bool
  description = "(Optional) Whether public network access is allowed for the Synapse Workspace."
  default     = true
}

variable "enable_managed_vnet" {
  type        = bool
  description = "(Optional) Is Virtual Network enabled for all computes in this workspace?"
  default     = true
}

variable "dep_enabled" {
  type        = bool
  description = "(Optional) Is data exfiltration protection enabled in this workspace?"
  default     = false
}

variable "identity_type" {
  type        = string
  description = "(Optional) Specifies the type of Managed Service Identity that should be configured on this Synapse Workspace."
  default     = null
}

variable "identity_ids" {
  type        = list(string)
  description = "(Optional) A list of User Assigned Identity IDs to be assigned to this Synapse Workspace."
  default     = null
}

variable "managed_rg_name" {
  type        = string
  description = "(Required) Name of the Workspace managed resource group."
}

variable "purview_id" {
  type        = string
  description = "(Optional) The ID of purview account."
  default     = null
}

variable "aad_admin" {
  type = object({
    login     = string
    object_id = string
    tenant_id = string
  })
  description = "(Optional) The 'login', 'object id' and 'tenant id' of the Azure AD Administrator of this Synapse Workspace."
  default = {
    login     = ""
    object_id = ""
    tenant_id = ""
  }
}

variable "create_spark_pool" {
  type        = bool
  description = "(Optional) Do you want to create a Synapse Spark Pool?"
  default     = false
}

variable "spark_pool_name" {
  type        = string
  description = "(Optional) The name which should be used for this Synapse Spark Pool. The value is required if `create_spark_pool` option is `true`."
  default     = ""
}

variable "spark_pool_family" {
  type        = string
  description = "(Optional) The kind of nodes that the Spark Pool provides. The value is required if `create_spark_pool` option is `true`."
  default     = "MemoryOptimized"
}

variable "spark_node_size" {
  type        = string
  description = "(Optional) The level of node in the Spark Pool. The value is required if `create_spark_pool` option is `true`."
  default     = "Medium"
}

variable "spark_version" {
  type        = string
  description = "(Optional) The Apache Spark version."
  default     = "3.2"
}

variable "spark_node_count" {
  type        = string
  description = "(Optional) The number of nodes in the Spark Pool."
  default     = "3"
}

variable "spark_pause_in_min" {
  type        = string
  description = "(Optional) Number of minutes of idle time before the Spark Pool is automatically paused. Must be between 5 and 10080."
  default     = "30"
}

variable "enable_spark_dynamic_executor" {
  type        = bool
  description = "(Optional) Indicates whether Dynamic Executor Allocation is enabled or not."
  default     = false
}

variable "min_spark_executor_size" {
  type        = string
  description = "(Optional) The minimum number of executors allocated only when `enable_spark_dynamic_executorty` set to `true`."
  default     = "2"
}

variable "max_spark_executor_size" {
  type        = string
  description = "(Optional) The maximun number of executors allocated only when `enable_spark_dynamic_executorty` set to `true`."
  default     = "4"
}

variable "spark_autoscale_setting" {
  type = object({
    max_node_count = string
    min_node_count = string
  })
  description = "(Optional) Specify the minimum and maximum number of nodes required for Spark Pool. Must be between `3` and `200`."
  default     = null
}

variable "spark_library_requirement" {
  type = object({
    content  = string
    filename = string
  })
  description = "(Optional) Specify the library requirments of the Spark Pool."
  default     = null
}

variable "spark_config" {
  type = object({
    content  = string
    filename = string
  })
  description = "(Optional) Specify the configuration of the Spark Pool."
  default     = null
}

variable "create_sql_pool" {
  type        = bool
  description = "(Optional) Do you want to create a Synapse SQL Pool?."
  default     = false
}

variable "sql_pool_name" {
  type        = string
  description = "(Optional) The name which should be used for this Synapse SQL Pool. The value is required `create_sql_pool` set to `true`."
  default     = ""
}

variable "sql_pool_sku" {
  type        = string
  description = "(Optional) Specifies the SKU Name for this Synapse SQL Pool."
  default     = "DW100c"
}

variable "sql_pool_create_mode" {
  type        = string
  description = "(Optional) Specifies how to create the SQL Pool."
  default     = "Default"
}

variable "sql_pool_collation" {
  type        = string
  description = " (Optional) The name of the collation to use with this pool."
  default     = "SQL_LATIN1_GENERAL_CP1_CI_AS"
}

variable "enable_tde" {
  type        = bool
  description = "(Optional) Is transparent data encryption enabled with this pool?"
  default     = true
}

variable "enable_sql_pool_backups" {
  type        = bool
  description = "(Optional) Is geo-backup policy enabled with this pool?"
  default     = true
}

variable "synapse_firewall_rules" {
  type = list(object({
    name     = string
    start_ip = string
    end_ip   = string
  }))
  description = "(Optional) The firewall rule details for Syanpse Workspace. The rule require a `name`, `start_ip` and `end_ip` details.."
  default     = null
}

variable "synapse_rbac_role_assignment" {
  type = list(object({
    role_name    = string
    principal_id = string
  }))
  description = "(Optional) Provide the details of syanpse role assignment. The role assignment required `role_name` and `principal_id` details."
  default     = null
}

variable "synapse_ir" {
  type = list(object({
    name             = string
    compute_type     = string
    core_count       = string
    description      = string
    time_to_live_min = string
  }))
  description = "(Optional) Provide details of Azure Managed Integration Runtime. The IR setup requires input for `name`, `compute_type`, `core_count`, `description` and `time_to_live_min`."
  default     = null
}

variable "synapse_managed_ir" {
  type = list(object({
    name = string
  }))
  description = "(Optional) Provide details of Self-Hosted Integration Runtime. The IR setup requires input for `name`."
  default     = null
}

variable "workspace_alert_container" {
  type        = string
  description = "(Optional) The name of blob container fo Synapse Workspace Alert configuration."
  default     = "workspace-alert-container"
}

variable "enable_synapse_workspace_alert" {
  type        = bool
  description = "(Optional) Do you want to configure alerts for Synapse workspace?"
  default     = false
}

variable "workspace_policy_state" {
  type        = string
  description = "(Optional) Do you want to enable the Synapse Workspace Alert Policy?"
  default     = "Enabled"
}

variable "workspace_disabled_alerts" {
  type        = list(string)
  description = "(Optional) Specifies an array of alerts that are disabled. Allowed values are: Sql_Injection, Sql_Injection_Vulnerability, Access_Anomaly, Data_Exfiltration, Unsafe_Action."
  default     = null
}

variable "email_account_admins_enabled" {
  type        = bool
  description = "(Optional) Boolean flag which specifies if the alert is sent to the account administrators or not."
  default     = false
}

variable "email_addresses" {
  type        = list(string)
  description = "(Optional) Specifies an array of email addresses to which the alert is sent."
  default     = [""]
}

variable "alert_retention_days" {
  type        = number
  description = "(Optional) Specifies the number of days to keep in the Threat Detection audit logs."
  default     = 15
}

variable "enable_recurring_scans" {
  type        = bool
  description = "(Optional) Boolean flag which specifies if recurring scans is enabled or disabled."
  default     = true
}

variable "enable_auditing" {
  type        = bool
  description = "(Optional) Do you want to enable auditing for synapse workspace?"
  default     = false
}

variable "audit_log_retention_days" {
  type        = number
  description = "(Optional) The number of days to retain audit logs in the storage account."
  default     = 7
}

variable "log_monitoring_enabled" {
  type        = bool
  description = "(Optional) Enable audit events to Azure Monitor? To enable server audit events to Azure Monitor, please enable its master database audit events to Azure Monitor."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "(Optional) A mapping of tags which should be assigned to the Synapse Workspace."
  default     = {}
}