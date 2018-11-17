# s3-kms-key

This module provides a KMS key configured for S3 usage.

```hcl
module "kms_key" {
  source = "github.com/jdhollis/s3-kms-key"
  
  additional_account_ids = ["…"]  # Account IDs for any accounts that need to be able to use the key when accessing bucket objects across accounts.
  alias = "…"  # Something descriptive.
  principals = ["…"]  # In a multi-account setup, this will most likely be the ARN of the assumed role.
}
```
