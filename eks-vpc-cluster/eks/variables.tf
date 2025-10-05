variable "project_name" {
  description = "Name of the EKS cluster"
  type = string
  default = "eks-cluster"
}

variable "profile" {
  description = "Profile"
  type = string
  default = "goit-terraform"
}

variable "cluster_version" {
  description = "Version of the EKS cluster"
  type = string
  default = "1.33"
}

variable "aws_region" {
  default = "us-east-1"
  description = "Default Region"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type = string
}

variable "public_subnets" {
  description = "Public subnets"
  type = list(string)
}
