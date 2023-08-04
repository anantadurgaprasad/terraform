terraform {
  backend "s3" {
    bucket = "demo-s3"
    key    = "Statefile/terraform.tfstate"
    region = "us-east-1"
  }
}