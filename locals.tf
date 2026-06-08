locals {
  tags = merge(
    var.disable_default_tags ? {} : {
      "truefoundry-terraform-module" = "efs"
      "truefoundry-managed"          = "true"
      "truefoundry-cluster-name"     = var.cluster_name
    },
    var.tags
  )
  efs_access_policy_default_prefix = "${var.cluster_name}-access-to-efs"
  efs_access_policy_prefix         = var.efs_access_policy_prefix_enable_override ? "${var.efs_access_policy_prefix_override_name}-${local.efs_access_policy_default_prefix}" : local.efs_access_policy_default_prefix
}
