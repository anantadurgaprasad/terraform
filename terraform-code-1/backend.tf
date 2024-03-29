terraform {
  backend "s3" {
   encrypt = true
   bucket  = "my-terragrunt-bucket"
   key = "Statefile/terraform.tfstate"
   region  = "us-east-1"
  }
}
