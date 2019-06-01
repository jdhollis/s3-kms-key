data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

data "aws_iam_policy_document" "key_policy" {
  statement {
    sid = "Allow account root access"

    principals {
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
      type        = "AWS"
    }

    actions   = ["*"]
    resources = ["*"]
  }

  statement {
    sid = "Allow access for key administrators"

    principals {
      identifiers = compact(var.principals)
      type        = "AWS"
    }

    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion",
    ]

    resources = ["*"]
  }

  statement {
    sid = "Allow use of the key by S3"

    principals {
      identifiers = ["*"]
      type        = "AWS"
    }

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      values   = ["s3.${data.aws_region.current.name}.amazonaws.com"]
      variable = "kms:ViaService"
    }

    condition {
      test = "StringEquals"

      values = concat(
        [data.aws_caller_identity.current.account_id],
        var.additional_account_ids
      )

      variable = "kms:CallerAccount"
    }
  }

  statement {
    sid = "Allow attachment of persistent resources"

    principals {
      identifiers = formatlist(
        "arn:aws:iam::%s:root",
        concat(
          [data.aws_caller_identity.current.account_id],
          var.additional_account_ids
        )
      )
      type = "AWS"
    }

    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant",
    ]

    resources = ["*"]

    condition {
      test     = "Bool"
      values   = ["true"]
      variable = "kms:GrantIsForAWSResource"
    }
  }
}

resource "aws_kms_key" "key" {
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.key_policy.json
}

resource "aws_kms_alias" "alias" {
  name          = "alias/${var.alias_name}"
  target_key_id = aws_kms_key.key.key_id
}

