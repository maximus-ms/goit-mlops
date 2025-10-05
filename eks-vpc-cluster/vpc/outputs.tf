output "vpc_id" {
  description = "The ID of the VPC"
  value = module.vpc.vpc_id
}

output "public_subnets" {
  value = module.vpc.public_subnets
  description = "Public subnet IDs"
}

output "private_subnets" {
  value = module.vpc.private_subnets
  description = "Private subnet IDs"
}