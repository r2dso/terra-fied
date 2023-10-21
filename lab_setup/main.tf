resource "random_uuid" "bucket_suffix" {}
resource "aws_s3_bucket" "lab_bucket" {
  bucket = "r2dso-state-bucket-${random_uuid.bucket_suffix.result}"  # Change this to your desired bucket name

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Demo"
  }
}

resource "aws_s3_bucket_versioning" "lab_s3_versioning" {
    bucket = aws_s3_bucket.lab_bucket.id
    versioning_configuration {
      status = "Enabled"
    }
}

output "bucket_name" {
  value = aws_s3_bucket.lab_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.lab_bucket.arn
}
