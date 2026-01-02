#checkov:skip=CKV_AWS_111:KMS key policy - resources='*' refers to this key only
#checkov:skip=CKV_AWS_356:KMS key policy - resources='*' refers to this key only
data "aws_iam_policy_document" "kms_usage" {
  statement {
    sid    = "AllowLambdaUsage"
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

module "example" {
  source = "../.."

  name   = "example-key"
  policy = data.aws_iam_policy_document.kms_usage.json

  tags = {
    Environment = "example"
  }
}
