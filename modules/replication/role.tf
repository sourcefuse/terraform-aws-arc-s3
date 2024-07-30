resource "random_id" "this" {
  byte_length = 4
}

resource "aws_iam_role" "this" {
  count = local.create_role ? 1 : 0

  name = "${var.source_bucket}-replication-${random_id.this.id}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "s3.amazonaws.com"
        }
      },
    ]
  })

  tags = var.tags
}

data "aws_iam_policy_document" "this" {
  count = local.create_role ? 1 : 0

  statement {
    effect = "Allow"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
      "s3:GetEncryptionConfiguration",
    ]

    resources = ["arn:aws:s3:::${var.source_bucket}"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetEncryptionConfiguration",
    ]
    resources = ["arn:aws:s3:::${var.source_bucket}/*"]
  }
}

resource "aws_iam_policy" "this" {
  count = local.create_role ? 1 : 0

  name   = "${var.source_bucket}-policy-replication-${random_id.this.id}"
  policy = data.aws_iam_policy_document.this[0].json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count = local.create_role ? 1 : 0

  role       = local.create_role ? aws_iam_role.this[0].name : var.replication_config.role_name
  policy_arn = aws_iam_policy.this[0].arn
}

data "aws_iam_policy_document" "dest" {
  for_each = local.create_role ? toset(local.destination_buckets) : []

  statement {
    effect = "Allow"

    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket",
      "s3:GetEncryptionConfiguration",
    ]
    resources = ["arn:aws:s3:::${each.value}"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging",
      "s3:GetEncryptionConfiguration",
    ]

    resources = ["arn:aws:s3:::${each.value}/*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags",
      "s3:PutEncryptionConfiguration",
    ]

    resources = ["arn:aws:s3:::${each.value}/*"]
  }
}

resource "aws_iam_policy" "dest" {
  for_each = local.create_role ? toset(local.destination_buckets) : []

  name   = "${each.value}-policy-replication-${random_id.this.id}"
  policy = data.aws_iam_policy_document.dest[each.value].json
  tags   = var.tags
}

resource "aws_iam_role_policy_attachment" "dest" {
  for_each = local.create_role ? toset(local.destination_buckets) : []

  role       = local.create_role ? aws_iam_role.this[0].name : var.replication_config.role_name
  policy_arn = aws_iam_policy.dest[each.value].arn
}

resource "aws_iam_policy" "kms" {
  for_each = local.kms_key_ids

  name        = "${local.environment}-kms-${var.source_bucket}-${random_id.this.id}"
  path        = "/"
  description = "IAM policy for kms access"

  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Action : [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource : data.aws_kms_key.this[each.value].arn,
        Effect : "Allow",
      }
    ]
  })
  tags = var.tags
}

# Attach kms policy to IAM role
resource "aws_iam_role_policy_attachment" "kms" {
  for_each = local.kms_key_ids

  role       = local.role_name
  policy_arn = aws_iam_policy.kms[each.value].arn
}
