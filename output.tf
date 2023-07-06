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
  value = module.iam_assumable_role_admin.iam_role_arn
}
