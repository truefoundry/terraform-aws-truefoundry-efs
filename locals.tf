locals {
  tags = merge(
    var.disable_default_tags ? {} : {
      "terraform-module" = "efs"
      "terraform"        = "true"
      "cluster-name"     = var.cluster_name
    },
    var.tags
  )
}
