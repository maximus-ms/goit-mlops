variable "project_name" {
  description = "Project name is used for naming resources"
  type = string
  default = "mlops-hw5"
}

variable "profile" {
  default = "goit-terraform"
  description = "Profile"
  type = string
}

variable "aws_region" {
  description = "Default Region"
  type = string
  default = "us-east-1"
}

