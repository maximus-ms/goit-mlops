module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"  # Pin to v5.x to be compatible with EKS module

  name = var.project_name
  cidr = var.vpc_cidr

  azs = [var.availability_zone, var.availability_zone_2]
  private_subnets = [var.private_subnet_cidr, var.private_subnet_cidr_2]
  public_subnets = [var.public_subnet_cidr, var.public_subnet_cidr_2]
  
  map_public_ip_on_launch = true
  enable_nat_gateway = true
}
