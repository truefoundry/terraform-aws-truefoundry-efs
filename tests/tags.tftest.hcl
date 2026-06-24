# Plan-only tag propagation test — INFRA-703
# Asserts that caller-supplied tags and the module's built-in defaults
# are present on managed IAM resources.

mock_provider "aws" {
  mock_data "aws_iam_policy_document" {
    defaults = {
      json = "{\"Version\":\"2012-10-17\",\"Statement\":[]}"
    }
  }
  mock_resource "aws_iam_policy" {
    defaults = {
      arn = "arn:aws:iam::123456789012:policy/mock-policy"
    }
  }
}

run "tags_applied" {
  command = plan

  variables {
    cluster_name                  = "test"
    region                        = "us-east-1"
    vpc_id                        = "vpc-00000000"
    private_subnets_id            = ["subnet-00000001", "subnet-00000002"]
    private_subnets_cidrs         = ["10.0.1.0/24", "10.0.2.0/24"]
    k8s_service_account_name      = "efs-csi-controller-sa"
    k8s_service_account_namespace = "kube-system"
    throughput_mode               = "elastic"
    performance_mode              = "generalPurpose"
    cluster_oidc_issuer_arn       = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
    efs_node_iam_role_arn         = "arn:aws:iam::123456789012:role/mock-node-role"
    tags                          = { "cost-center" = "test-123" }
  }

  # Caller tag propagates to the EFS IAM policy
  assert {
    condition     = aws_iam_policy.efs[0].tags["cost-center"] == "test-123"
    error_message = "Expected cost-center=test-123 on aws_iam_policy.efs, got: ${aws_iam_policy.efs[0].tags["cost-center"]}"
  }

  # Module default tag is present
  assert {
    condition     = aws_iam_policy.efs[0].tags["truefoundry-terraform-module"] == "efs"
    error_message = "Expected truefoundry-terraform-module=efs on aws_iam_policy.efs, got: ${aws_iam_policy.efs[0].tags["truefoundry-terraform-module"]}"
  }

  # Module managed tag is present
  assert {
    condition     = aws_iam_policy.efs[0].tags["truefoundry-managed"] == "true"
    error_message = "Expected truefoundry-managed=true on aws_iam_policy.efs, got: ${aws_iam_policy.efs[0].tags["truefoundry-managed"]}"
  }
}

run "disable_default_tags" {
  command = plan

  variables {
    cluster_name                  = "test"
    region                        = "us-east-1"
    vpc_id                        = "vpc-00000000"
    private_subnets_id            = ["subnet-00000001", "subnet-00000002"]
    private_subnets_cidrs         = ["10.0.1.0/24", "10.0.2.0/24"]
    k8s_service_account_name      = "efs-csi-controller-sa"
    k8s_service_account_namespace = "kube-system"
    throughput_mode               = "elastic"
    performance_mode              = "generalPurpose"
    cluster_oidc_issuer_arn       = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.us-east-1.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
    efs_node_iam_role_arn         = "arn:aws:iam::123456789012:role/mock-node-role"
    tags                          = { "cost-center" = "test-123" }
    disable_default_tags          = true
  }

  # Caller tag is still present when default tags are disabled
  assert {
    condition     = aws_iam_policy.efs[0].tags["cost-center"] == "test-123"
    error_message = "Expected cost-center=test-123 on aws_iam_policy.efs, got: ${aws_iam_policy.efs[0].tags["cost-center"]}"
  }

  # truefoundry-terraform-module must be absent when disable_default_tags=true
  assert {
    condition     = !contains(keys(aws_iam_policy.efs[0].tags), "truefoundry-terraform-module")
    error_message = "Expected truefoundry-terraform-module to be absent when disable_default_tags=true"
  }
}
