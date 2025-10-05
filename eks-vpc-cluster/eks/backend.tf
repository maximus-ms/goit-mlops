terraform {
 backend "s3" {
  bucket = "mlops-tfstate-maksymp"
  key = "global/hw5/eks/terraform.tfstate"
  region = "us-east-1"
  encrypt = true
  profile = "goit-terraform"
 }
}
