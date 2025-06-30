locals {
  tags = merge(
    {
      "terraform-module" = "efs"
      "terraform"        = "true"
      "cluster-name"     = var.cluster_name
    },
    var.tags
  )

  # Get unique AZs from provided subnets
  subnet_azs = distinct([
    for subnet_id, subnet in data.aws_subnet.private : subnet.availability_zone
  ])

  # Create AZ to subnet mapping (first subnet found in each AZ)
  az_to_subnet = {
    for az in local.subnet_azs : az => [
      for subnet_id, subnet in data.aws_subnet.private : subnet_id
      if subnet.availability_zone == az
    ][0]
  }

  # Extract the subnet IDs for EFS (one per AZ)
  efs_subnets = values(local.az_to_subnet)

  # Get corresponding CIDR blocks for security groups
  efs_subnet_cidrs = [
    for subnet_id in local.efs_subnets :
    data.aws_subnet.private[subnet_id].cidr_block
  ]
}

# Get subnet information to determine their availability zones
data "aws_subnet" "private" {
  for_each = toset(var.private_subnets_id)
  id       = each.value
}

# Get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

