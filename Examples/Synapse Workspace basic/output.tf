#The Output Section 

output "syn_id" {
  description = "The ID of the newly created synapse workspace."
  value       = module.examplesyn01.syn_id
}