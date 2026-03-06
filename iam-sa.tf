# From https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/irsa/irsa.tf


module "iam_assumable_role_admin" {
  count           = var.create_efs_iam_role ? 1 : 0
  source          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version         = "6.2.3"
  create          = true
  name            = var.efs_iam_role_enable_override ? var.efs_iam_role_override_name : "${var.cluster_name}-efs"
  use_name_prefix = var.efs_iam_role_use_name_prefix
  oidc_providers = {
    efs = {
      provider_arn               = var.cluster_oidc_issuer_arn
      namespace_service_accounts = ["${var.k8s_service_account_namespace}:${var.k8s_service_account_name}"]
    }
  }
  policies = merge({
    efs_access = var.create_efs_access_policy ? aws_iam_policy.efs[0].arn : var.existing_efs_access_policy_arn
  }, var.efs_iam_role_additional_policies)
  permissions_boundary = var.efs_iam_role_permissions_boundary_arn
  tags                 = local.tags

}

moved {
  from = module.iam_assumable_role_admin
  to   = module.iam_assumable_role_admin[0]
}