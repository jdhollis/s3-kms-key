# s3-kms-key

This module provides a KMS key configured for S3 usage.

## Usage

If you're using Terraform >= 0.12.0, you can rely on the latest master.

```hcl-terraform
module "kms_key" {
  source = "github.com/jdhollis/s3-kms-key"
  
  additional_account_ids = ["…"]  # Account IDs for any accounts that need to be able to use the key when accessing bucket objects across accounts.
  alias                  = "…"    # Something descriptive.
  principals             = ["…"]  # In a multi-account setup, this will most likely be the ARN of the assumed role.
}
```

### Terraform 0.11.x

If you're using Terraform 0.11.x, you'll want to lock your module source to 0.11.x.

```hcl-terraform
module "kms_key" {
  source = "github.com/jdhollis/s3-kms-key?ref=0.11.x"
  …
}
```
