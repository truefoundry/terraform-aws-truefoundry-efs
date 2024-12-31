# Upgrade Guide

This guide will help you to migrate your terraform code across versions. Keeping your terraform state to the latest version is always recommeneded

## 0.3.x to 0.4.x

### Breaking Changes

1. The EFS filesystem resource name has been changed from [aws_efs_module](https://registry.terraform.io/modules/terraform-aws-modules/efs/aws/latest) to [cloudposse_efs](https://registry.terraform.io/modules/cloudposse/efs/aws/latest), due to count dependency on data block inputs. This helps us generate a one-shot plan for the whole Truefoundry installation.

### Required Actions

1. Ensure that you are running on the latest version of 0.3.x which is [0.3.5](https://github.com/truefoundry/terraform-aws-truefoundry-efs/releases/tag/v0.3.5)
2. Move to version `0.4.0` and run the following command
   ```shell
   terraform init -upgrade
   ```
3. Run the following commands to do the migration. Depending upon your availability zones migrate the list indices. For example if you have 3 AZs, then you list indicies should be from 0-2. Below is an example for 4 AZs in `us-east-1` region. Change them according to your region and AZs.
   ```shell
    terraform state mv 'module.efs.aws_efs_file_system.this[0]' 'module.efs.aws_efs_file_system.default[0]'
    terraform state mv 'module.efs.aws_efs_backup_policy.this[0]' 'module.efs.aws_efs_backup_policy.policy[0]'
    terraform state mv 'module.efs.aws_efs_file_system_policy.this[0]' 'aws_efs_file_system_policy.this'
    terraform state mv 'module.efs.aws_efs_mount_target.this["us-east-1a"]' 'module.efs.aws_efs_mount_target.default[0]'
    terraform state mv 'module.efs.aws_efs_mount_target.this["us-east-1b"]' 'module.efs.aws_efs_mount_target.default[1]'
    terraform state mv 'module.efs.aws_efs_mount_target.this["us-east-1c"]' 'module.efs.aws_efs_mount_target.default[2]'
    terraform state mv 'module.efs.aws_efs_mount_target.this["us-east-1d"]' 'module.efs.aws_efs_mount_target.default[3]'
   ```
4. Run the plan to check if the filesystem is not destroyed or re-created. Security groups and mount targets can be destroyed or re-created and won't impact your data.
   ```shell
   terraform plan
   ```
5. Run the apply
   ```shell
   terraform apply
   ```
