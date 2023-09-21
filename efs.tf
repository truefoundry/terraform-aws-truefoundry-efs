resource "aws_iam_policy" "efs" {
  name_prefix = "${var.cluster_name}-access-to-efs"
  description = "EFS Access policy for cluster"
  policy      = data.aws_iam_policy_document.efs.json
  tags = local.tags
}
# https://github.com/kubernetes-sigs/aws-efs-csi-driver/blob/master/docs/iam-policy-example.json
data "aws_iam_policy_document" "efs" {
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems",
      "elasticfilesystem:DescribeMountTargets",
      "ec2:DescribeAvailabilityZones"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:DeleteAccessPoint"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringEquals"
      values   = ["true"]
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:TagResource"
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringLike"
      values   = ["true"]
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"
    }
  }
  statement {
    effect = "Allow"
    actions = [
      "elasticfilesystem:CreateAccessPoint",
    ]
    resources = [
      "*"
    ]
    condition {
      test     = "StringLike"
      values   = ["true"]
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
    }
  }
}

module "efs" {
  source  = "terraform-aws-modules/efs/aws"
  version = "1.1.1"

  name = "${var.cluster_name}-efs"

  mount_targets              = { for k, v in zipmap(var.azs, var.private_subnets_id) : k => { subnet_id = v } }
  security_group_description = "${var.cluster_name} EFS"
  security_group_vpc_id      = var.vpc_id
  attach_policy              = false
  throughput_mode            = var.throughput_mode
  performance_mode           = var.performance_mode
  security_group_rules = {
    vpc = {
      # relying on the defaults provdied for EFS/NFS (2049/TCP + ingress)
      description = "NFS ingress from VPC private subnets"
      cidr_blocks = var.private_subnets_cidrs
    }
  }

  tags = merge(
    local.tags
  )
}
