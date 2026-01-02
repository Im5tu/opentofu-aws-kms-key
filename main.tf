resource "aws_kms_key" "this" {
  policy                             = data.aws_iam_policy_document.this.json
  description                        = var.description
  key_usage                          = var.key_usage
  bypass_policy_lockout_safety_check = var.bypass_policy_lockout_safety_check
  deletion_window_in_days            = var.deletion_window_in_days
  customer_master_key_spec           = var.customer_master_key_spec
  enable_key_rotation                = var.enable_key_rotation
  multi_region                       = var.multi_region
  tags = merge(
    {
      "Name" = var.name
    },
    var.tags
  )
}

resource "aws_kms_alias" "this" {
  name          = "alias/${var.name}"
  target_key_id = aws_kms_key.this.key_id
}

data "aws_iam_policy_document" "key_management" {
  statement {
    sid    = "AllowRootFullManagement"
    effect = "Allow"
    actions = [
      "kms:*"
    ]
    resources = ["*"]

    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
      ]
      type = "AWS"
    }
  }

  statement {
    sid    = "AllowInfrastructureDeployerManagement"
    effect = "Allow"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Get*",
      "kms:TagResource",
      "kms:UntagResource"
    ]
    resources = ["*"]

    principals {
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/InfrastructureDeployer"
      ]
      type = "AWS"
    }
  }
}

# Compose the final KMS key policy from the management policy and var.policy
# Note: var.policy is composed with the key_management policy above
# Ensure var.policy follows principle of least privilege and does not grant overly broad actions
data "aws_iam_policy_document" "this" {
  source_policy_documents = [data.aws_iam_policy_document.key_management.json, var.policy]
}