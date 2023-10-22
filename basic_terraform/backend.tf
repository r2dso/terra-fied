terraform {
  backend "s3" {
    bucket = "r2dso-training"
    key    = "basic_terraform.tfstate"
    region = "us-east-1"
  }
}
