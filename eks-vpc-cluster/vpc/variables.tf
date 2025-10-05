variable "project_name" {
  description = "Project name is used for naming resources"
  type = string
  default = "vpc-project"
}

variable "profile" {
  description = "Profile"
  type = string
  default = "goit-terraform"
}

variable "aws_region" {
  description = "Default Region"
  type = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
  type = string
  description = "CIDR for the VPC"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
  type = string
  description = "CIDR for public subnet"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
  type = string
  description = "CIDR for private subnet"
}

variable "public_subnet_cidr_2" {
  description = "CIDR block for the second public subnet"
  type = string
  default = "10.0.3.0/24"
}

variable "private_subnet_cidr_2" {
  description = "CIDR block for the second private subnet"
  type = string
  default = "10.0.4.0/24"
}

variable "availability_zone" {
  default = "us-east-1a"
  type = string
  description = "Availability Zone для сабнетів"
}

variable "availability_zone_2" {
  description = "Second AZ for multi-AZ subnets"
  type = string
  default = "us-east-1b"
}