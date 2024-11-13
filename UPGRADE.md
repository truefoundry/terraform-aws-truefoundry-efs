# Upgrade Guide

This guide helps you upgrade the EFS module from version v0.3.5 and below to newer versions.

## From v0.3.5 to v0.4.0

### Breaking Changes

1. The EFS filesystem resource name has been changed from [aws_efs_module](https://registry.terraform.io/modules/terraform-aws-modules/efs/aws/latest) to [cloudposse_efs](https://registry.terraform.io/modules/cloudposse/efs/aws/latest), due to count dependency on data block inputs. This helps us generate a one-shot plan for the whole Truefoundry installation.

### Required Actions

Before running `terraform plan`, you need to migrate the state of the EFS filesystem resource to prevent destruction and recreation. Execute the following command:

```bash
terraform state mv 'module.efs.module.efs.aws_efs_file_system.default[0]' 'module.efs.module.efs.aws_efs_file_system.this[0]'
```
