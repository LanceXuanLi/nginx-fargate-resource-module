data "aws_elb_service_account" "elb_account_id" {}

# https://docs.aws.amazon.com/elasticloadbalancing/latest/classic/enable-access-logs.html
data "aws_iam_policy_document" "allow_elb_logging" {
  statement {
    principals {
      identifiers = [data.aws_elb_service_account.elb_account_id.arn]
      type = "AWS"
    }

    actions = ["s3:PutObject"]

    resources = [
      "${aws_s3_bucket.s3.arn}/*"
    ]
  }
}
resource "aws_s3_bucket" s3 {
  bucket = var.s3-bucket
  force_destroy = true

  tags = {
    Name = var.s3-bucket
    Env  = var.s3-env
  }
}


resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.s3.id
  policy = data.aws_iam_policy_document.allow_elb_logging.json
}

resource "aws_s3_bucket_server_side_encryption_configuration" "example" {
  bucket = aws_s3_bucket.s3.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}