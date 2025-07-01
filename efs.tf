resource "aws_iam_policy" "efs" {
  count       = var.create_efs_iam_role ? 1 : 0
  name_prefix = "${var.cluster_name}-access-to-efs"
  description = "EFS Access policy for cluster"
  policy      = data.aws_iam_policy_document.efs.json
  tags        = local.tags
}

resource "aws_efs_file_system_policy" "this" {
  file_system_id                     = module.efs.id
  bypass_policy_lockout_safety_check = false
  policy                             = data.aws_iam_policy_document.efs_file_system_policy.json
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
    resources = ["*"]
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

# EFS file system policy
data "aws_iam_policy_document" "efs_file_system_policy" {
  statement {
    effect  = "Allow"
    actions = ["elasticfilesystem:ClientMount", "elasticfilesystem:ClientWrite", "elasticfilesystem:ClientRootAccess"]
    principals {
      type        = "AWS"
      identifiers = [var.efs_node_iam_role_arn]
    }
    condition {
      test     = "Bool"
      values   = ["true"]
      variable = "elasticfilesystem:AccessedViaMountTarget"
    }
    resources = [module.efs.arn]
  }
}

# EFS Module - using filtered subnets to ensure only one subnet per AZ
# This prevents mount target creation failures when multiple subnets exist in the same AZ
module "efs" {
  source  = "cloudposse/efs/aws"
  version = "1.1.0"

  region           = var.region
  vpc_id           = var.vpc_id
  subnets          = local.efs_subnets
  allow_all_egress = false

  allowed_cidr_blocks   = var.private_subnets_cidrs
  create_security_group = true
  name                  = "${var.cluster_name}-efs"

  security_group_description         = "${var.cluster_name} EFS"
  bypass_policy_lockout_safety_check = false
  throughput_mode                    = var.throughput_mode
  performance_mode                   = var.performance_mode
  efs_backup_policy_enabled          = var.enable_backup_policy

  tags = merge(
    local.tags
  )
}

moved {
  from = aws_iam_policy.efs
  to   = aws_iam_policy.efs[0]
}
