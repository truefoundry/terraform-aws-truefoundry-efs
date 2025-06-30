locals {
  tags = merge(
    {
      "terraform-module" = "efs"
      "terraform"        = "true"
      "cluster-name"     = var.cluster_name
    },
    var.tags
  )
  # Create a map of AZ to subnet ID, ensuring only one subnet per AZ
  # Group subnets by availability zone
  subnets_by_az = {
    for subnet_id, subnet_data in data.aws_subnet.efs_subnets :
    subnet_data.availability_zone => subnet_id...
  }

  # Select the first subnet from each AZ for EFS mount targets
  efs_subnets = [
    for az, subnet_ids in local.subnets_by_az :
    subnet_ids[0]
  ]

  # Get CIDR blocks for the selected EFS subnets
  efs_subnet_cidrs = [
    for subnet_id in local.efs_subnets :
    data.aws_subnet.efs_subnets[subnet_id].cidr_block
  ]
}
# Get subnet information to determine their availability zones
data "aws_subnet" "efs_subnets" {
  for_each = toset(var.private_subnets_id)
  id       = each.value
}

