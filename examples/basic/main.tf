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
