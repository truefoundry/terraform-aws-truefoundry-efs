output "efs_arn" {
  value = module.efs.arn
}

output "efs_id" {
  value = module.efs.id
}

output "efs_security_group_id" {
  value = module.efs.security_group_id
}

output "efs_role_arn" {
  value = var.create_efs_iam_role ? module.iam_assumable_role_admin[0].iam_role_arn : var.existing_efs_iam_role_arn
}

# Output to show which subnets were selected for EFS mount targets
output "efs_selected_subnets" {
  description = "Subnets selected for EFS mount targets (one per AZ)"
  value       = local.efs_subnets
}
