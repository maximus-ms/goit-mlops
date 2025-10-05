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

output "cluster_arn" {
  value = module.eks.cluster_arn
  description = "The Amazon Resource Name (ARN) of the cluster"
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
  description = "The endpoint for your EKS Kubernetes API."
}

output "cluster_name" {
  value = module.eks.cluster_name
  description = "The name of the EKS cluster"
}

output "node_groups" {
  value = module.eks.node_groups
  description = "Information about the node groups"
}
