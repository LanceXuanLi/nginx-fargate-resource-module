resource "aws_s3_bucket" s3 {
  bucket = var.s3-bucket

  tags = {
    Name = var.s3-bucket
    Env  = var.s3-env
  }
}

resource "aws_s3_bucket_versioning" "s3" {
  bucket = aws_s3_bucket.s3.id
  versioning_configuration {
    status = "Enabled"
  }
}