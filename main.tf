provider "aws" {
  region = "us-east-2" # Destination
}

provider "aws" {
  alias  = "east1"
  region = "us-east-1" # Source
}

# Create destination bucket
resource "aws_s3_bucket" "destination" {
  bucket = "tf-fixed-destination-bucket-67890"
}

resource "aws_s3_bucket_versioning" "destination" {
  bucket = aws_s3_bucket.destination.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Create source bucket
resource "aws_s3_bucket" "source" {
  provider = aws.east1
  bucket   = "tf-fixed-source-bucket-67890"
}

resource "aws_s3_bucket_versioning" "source" {
  provider = aws.east1
  bucket   = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}

# IAM Role for replication
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "replication" {
  name               = "tf-iam-role-replication-12345"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# IAM policy document
data "aws_iam_policy_document" "replication" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetReplicationConfiguration",
      "s3:ListBucket"
    ]
    resources = [aws_s3_bucket.source.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:GetObjectVersionForReplication",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectVersionTagging"
    ]
    resources = ["${aws_s3_bucket.source.arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ReplicateObject",
      "s3:ReplicateDelete",
      "s3:ReplicateTags"
    ]
    resources = ["${aws_s3_bucket.destination.arn}/*"]
  }
}

resource "aws_iam_policy" "replication" {
  name   = "tf-iam-policy-replication-12345"
  policy = data.aws_iam_policy_document.replication.json
}

resource "aws_iam_role_policy_attachment" "replication" {
  role       = aws_iam_role.replication.name
  policy_arn = aws_iam_policy.replication.arn
}

# Add bucket policy to source bucket to allow replication role access
resource "aws_s3_bucket_policy" "source_policy" {
  provider = aws.east1
  bucket   = aws_s3_bucket.source.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "ReplicationPermissions",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.replication.arn
        },
        Action = [
          "s3:GetObjectVersion",
          "s3:GetObjectVersionAcl",
          "s3:GetObjectVersionTagging",
          "s3:ReplicateObject",
          "s3:ReplicateDelete",
          "s3:ReplicateTags"
        ],
        Resource = "${aws_s3_bucket.source.arn}/*"
      },
      {
        Sid    = "ListBucketAndReplicationConfig",
        Effect = "Allow",
        Principal = {
          AWS = aws_iam_role.replication.arn
        },
        Action = [
          "s3:ListBucket",
          "s3:GetReplicationConfiguration"
        ],
        Resource = aws_s3_bucket.source.arn
      }
    ]
  })
}

# Replication config
resource "aws_s3_bucket_replication_configuration" "replication" {
  provider   = aws.east1
  depends_on = [
    aws_s3_bucket_versioning.source,
    aws_s3_bucket_policy.source_policy
  ]

  role   = aws_iam_role.replication.arn
  bucket = aws_s3_bucket.source.id

  rule {
    id     = "example-rule"
    status = "Enabled"

    filter {
      prefix = ""
    }

    delete_marker_replication {
      status = "Disabled"
    }

    destination {
      bucket        = aws_s3_bucket.destination.arn
      storage_class = "STANDARD"
    }
  }
}
