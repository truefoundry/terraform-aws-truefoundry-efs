# From https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/examples/irsa/irsa.tf

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "iam_assumable_role_admin" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.27.0"

  create_role  = true
  role_name    = "${var.cluster_name}-efs"
  provider_url = replace(var.cluster_oidc_issuer_url, "https://", "")
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${var.k8s_service_account_namespace}:${var.k8s_service_account_name}"
  ]

  role_policy_arns = [
    aws_iam_policy.efs.arn
  ]
}