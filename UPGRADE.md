# Upgrade Guide

This guide helps you upgrade the EFS module from version v0.3.5 and below to newer versions.

## From v0.3.5 to v0.4.0

### Breaking Changes

1. The EFS filesystem resource name has been changed from [aws_efs_module](https://registry.terraform.io/modules/terraform-aws-modules/efs/aws/latest) to [cloudposse_efs](https://registry.terraform.io/modules/cloudposse/efs/aws/latest), due to count dependency on data block inputs. This helps us generate a one-shot plan for the whole Truefoundry installation.

### Required Actions

1. First, create a backup of your terraform state:

```bash
# For local state
terraform state pull > terraform.tfstate.backup.$(date +%Y%m%d_%H%M%S)
```

2. Before running `terraform plan`, you need to migrate the state of the EFS resources to prevent destruction and recreation. Execute the following commands in order:

```bash
# Move EFS file system
terraform state mv 'module.efs.module.efs.aws_efs_file_system.default[0]' 'module.efs.module.efs.aws_efs_file_system.this[0]'

# Move mount targets
terraform state mv 'module.efs.module.efs.aws_efs_mount_target.default[0]' 'module.efs.module.efs.aws_efs_mount_target.this[0]'
terraform state mv 'module.efs.module.efs.aws_efs_mount_target.default[1]' 'module.efs.module.efs.aws_efs_mount_target.this[1]'
terraform state mv 'module.efs.module.efs.aws_efs_mount_target.default[2]' 'module.efs.module.efs.aws_efs_mount_target.this[2]'

# Move file system policy
terraform state mv 'module.efs.aws_efs_file_system_policy.default' 'module.efs.aws_efs_file_system_policy.this'

# Move backup policy
terraform state mv 'module.efs.module.efs.aws_efs_backup_policy.default[0]' 'module.efs.module.efs.aws_efs_backup_policy.policy[0]'

### Verification Steps

1. Run all the state move commands mentioned above
2. Execute `terraform plan`
3. Verify that the plan does not show destruction of any EFS resources
4. The plan should only show changes related to the resource name changes
5. If the plan shows EFS resource destruction, DO NOT APPLY and review the state migration steps

### Notes

- Always backup your Terraform state before performing any state migrations
- Test these changes in a non-production environment first
- If you encounter any issues during the upgrade, please refer to the module documentation or open an issue in the repository
- Make sure to execute the state move commands in the order specified above
- If you have a different number of mount targets, adjust the mount target migration commands accordingly
