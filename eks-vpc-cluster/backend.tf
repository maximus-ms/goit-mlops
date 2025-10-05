terraform {
 backend "s3" {
  bucket = "mlops-tfstate-maksymp"
  key = "global/hw5/terraform.tfstate"
  region = "us-east-1"
  profile = "goit-terraform"
  encrypt = true
 }
}