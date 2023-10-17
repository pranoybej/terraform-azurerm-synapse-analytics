# The Output Section of the Synapse Workspace Module

output "rg_id" {
  description = "The ID of the newly created Resource Group."
  value       = var.create_resource_group ? azurerm_resource_group.rg.*.id : null
}

output "str_id" {
  description = "The ID of the newly created Stroage Account."
  value       = var.create_storage_account ? azurerm_storage_account.str.*.id : null
}

output "dlg2_id" {
  description = "The ID of the newly created Data Lake Gen2 file system."
  value       = azurerm_storage_data_lake_gen2_filesystem.dlg2.id
}

output "syn_id" {
  description = "The ID of the newly created synapse Workspace."
  value       = azurerm_synapse_workspace.syn.id
}

output "syn_cep" {
  description = "A list of Connectivity endpoints for this Synapse Workspace."
  value       = azurerm_synapse_workspace.syn.connectivity_endpoints
}

output "spk_id" {
  description = "The ID of the newly created Synapse Spark Pool."
  value       = var.create_spark_pool ? azurerm_synapse_spark_pool.spk.*.id : null
}

output "sql_pool_id" {
  description = "The ID of the newly created Syanpse SQL Pool."
  value       = var.create_sql_pool ? azurerm_synapse_sql_pool.synsql.*.id : null
}

output "sh_ir_id" {
  description = "The ID of the Synapse Self-hosted Integration Runtime."
  value       = var.synapse_managed_ir != null ? azurerm_synapse_integration_runtime_self_hosted.syn_sh_id.*.id : null
}

output "sh_ir_pkey" {
  description = "The primary self-hosted integration runtime authentication key."
  value       = var.synapse_managed_ir != null ? azurerm_synapse_integration_runtime_self_hosted.syn_sh_id.*.authorization_key_primary : null
}

output "sh_ir_skey" {
  description = "The secondary self-hosted integration runtime authentication key."
  value       = azurerm_synapse_integration_runtime_self_hosted.syn_sh_id.*.authorization_key_secondary
}

output "wksp_alrt_cntnr_name" {
  description = "The name of the blob contianer where vulnerability scan results are stored."
  value       = var.enable_synapse_workspace_alert ? azurerm_storage_container.workspace_container.*.name : null
}

output "wksp_alrt_plcy_id" {
  description = "The ID of the Synapse Workspace Security Alert Policy."
  value       = var.enable_synapse_workspace_alert ? azurerm_synapse_workspace_security_alert_policy.syn_alrt.*.id : null
}

output "wksp_vuln_asmnt_id" {
  description = "The ID of the Synapse Workspace Vulnerability Assessment."
  value       = var.enable_synapse_workspace_alert ? azurerm_synapse_workspace_vulnerability_assessment.syn_vuln.*.id : null
}

output "syn_adt_id" {
  description = "The ID of the Synapse Workspace Extended Auditing Policy."
  value       = var.enable_auditing ? azurerm_synapse_workspace_extended_auditing_policy.syn_adt.*.id : null
}