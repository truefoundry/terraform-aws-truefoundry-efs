data "aws_subnet" "selected" {
  count = length(var.private_subnets_id)
  id    = var.private_subnets_id[count.index]
}

locals {
  tags = merge(
    {
      "terraform-module" = "efs"
      "terraform"        = "true"
      "cluster-name"     = var.cluster_name
    },
    var.tags
  )
  subnets = merge({ for _, v in data.aws_subnet.selected : v.availability_zone => v.id... })
  mount_targets = merge({ for k, v in local.subnets : k => {
    subnet_id = v[0]
  } })
}