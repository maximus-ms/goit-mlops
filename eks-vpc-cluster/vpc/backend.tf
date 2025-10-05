terraform {
 backend "s3" {
  bucket = "mlops-tfstate-maksymp"
  key = "global/hw5/vpc/terraform.tfstate"
  encrypt = true
  region = "us-east-1"
  profile = "goit-terraform"
 }
}