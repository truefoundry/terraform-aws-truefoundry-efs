locals {
  tags = merge(
    {
      "terraform-module" = "efs"
      "terraform"        = "true"
      "cluster-name"     = var.cluster_name
    },
    var.tags
  )

  # ============================================================================
  # EFS SUBNET SELECTION LOGIC
  # ============================================================================
  # PROBLEM: EFS requires exactly one mount target per AZ, but users may provide
  # multiple subnets in the same AZ. We need to consistently select the same 
  # subnet for each AZ, even when new subnets are added to the input list.
  #
  # SOLUTION: Always use the FIRST subnet from the input list for each AZ.
  # This ensures that adding new subnets doesn't change existing mount targets.
  # ============================================================================

  # Create a mapping: AZ -> first subnet ID from input list for that AZ
  # We iterate through var.private_subnets_id in order and use index position
  # to ensure we always pick the first occurrence of each AZ
  az_to_subnet = {
    for i, subnet_id in var.private_subnets_id :
    data.aws_subnet.private[subnet_id].availability_zone => subnet_id
    if !contains([
      # Check all previous subnets to see if we've seen this AZ before
      for j in range(i) :
      data.aws_subnet.private[var.private_subnets_id[j]].availability_zone
    ], data.aws_subnet.private[subnet_id].availability_zone)
  }

  # Extract the subnet IDs for EFS (one per AZ, maintaining input order)
  efs_subnets = values(local.az_to_subnet)
}

# Get subnet information to determine their availability zones
data "aws_subnet" "private" {
  for_each = toset(var.private_subnets_id)
  id       = each.value
}
