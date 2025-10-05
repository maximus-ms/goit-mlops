module "vpc" {
  source = "./vpc"
  project_name = var.project_name
  aws_region = var.aws_region
  profile = var.profile
}

module "eks" {
  source = "./eks"
  project_name = var.project_name
  aws_region = var.aws_region
  vpc_id = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  profile = var.profile
}