resource "random_uuid" "bucket_suffix" {}
resource "aws_s3_bucket" "lab_bucket" {
  bucket = "r2dso-lab-bucket-${random_uuid.bucket_suffix.result}"  # Change this to your desired bucket name

  tags = {
    Name        = "Public Bucket"
    Environment = "Demo"
  }
}

resource "aws_s3_bucket_versioning" "lab_s3_versioning" {
    bucket = aws_s3_bucket.lab_bucket.id
    versioning_configuration {
      status = "Enabled"
    }
}

resource "aws_s3_bucket_ownership_controls" "lab_s3_ownership_controls" {
  bucket = aws_s3_bucket.lab_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "lab_s3_public_access_block" {
  bucket = aws_s3_bucket.lab_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "lab_s3_bucket_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.lab_s3_ownership_controls, aws_s3_bucket_public_access_block.lab_s3_public_access_block]
  bucket = aws_s3_bucket.lab_bucket.id
  acl    = "public-read"
}

output "bucket_name" {
  value = aws_s3_bucket.lab_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.lab_bucket.arn
}
