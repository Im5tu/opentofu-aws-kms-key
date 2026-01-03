# OpenTofu AWS KMS Key Module

Creates an AWS KMS key with alias and configurable key policy. Includes an anti-lockout policy granting root account access and management permissions for an InfrastructureDeployer role.

## Usage

```hcl
data "aws_iam_policy_document" "kms_usage" {
  statement {
    sid    = "AllowServiceUsage"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey*"
    ]
    resources = ["*"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

module "kms_key" {
  source = "git::https://github.com/im5tu/opentofu-aws-kms-key.git?ref=693ded6a9b71a3ad71b006b86cd381979b196304"

  name   = "my-application-key"
  policy = data.aws_iam_policy_document.kms_usage.json

  tags = {
    Environment = "production"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| opentofu | >= 1.9 |
| aws | ~> 6 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the key | `string` | n/a | yes |
| policy | The KMS key policy to apply in addition to the management policy | `string` | n/a | yes |
| description | The description of the KMS key | `string` | `""` | no |
| enable_key_rotation | Specifies whether key rotation is enabled | `bool` | `true` | no |
| bypass_policy_lockout_safety_check | Bypass the key policy lockout safety check | `bool` | `false` | no |
| deletion_window_in_days | Waiting period before key deletion (7-30 days) | `number` | `30` | no |
| customer_master_key_spec | Key spec: SYMMETRIC_DEFAULT, RSA_*, ECC_* | `string` | `"SYMMETRIC_DEFAULT"` | no |
| multi_region | Whether this is a multi-region key | `bool` | `false` | no |
| key_usage | Intended use: ENCRYPT_DECRYPT or SIGN_VERIFY | `string` | `"ENCRYPT_DECRYPT"` | no |
| tags | Additional tags to apply to the key | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| key_arn | The KMS key ARN |
| key_id | The KMS key ID |
| key_alias_arn | The KMS key alias ARN |
| key_alias_id | The KMS key alias ID |

## Key Policy

This module creates a key policy with:

1. **Root anti-lockout** - Grants `kms:*` to the account root principal to prevent key lockout scenarios
2. **InfrastructureDeployer management** - Grants management permissions to the `InfrastructureDeployer` role
3. **Custom policy** - Merges your provided policy for service/application access

## Development

### Validation

This module uses GitHub Actions for validation:

- **Format check**: `tofu fmt -check -recursive`
- **Validation**: `tofu validate`
- **Security scanning**: Checkov, Trivy

### Local Development

```bash
# Format code
tofu fmt -recursive

# Validate
tofu init -backend=false
tofu validate
```

## License

MIT License - see [LICENSE](LICENSE) for details.
