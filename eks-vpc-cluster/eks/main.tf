module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name = var.project_name
  cluster_version = var.cluster_version

  vpc_id = var.vpc_id
  subnet_ids = var.public_subnets

  cluster_endpoint_public_access = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    coredns = {}
    eks-pod-identity-agent = {}
    kube-proxy = {}
    vpc-cni = {}
  }

  eks_managed_node_group_defaults = {
    instance_types = ["t3.medium"]
  }

  eks_managed_node_groups = {
    cpu-nodes = {
      name = "cpu-nodes"
      instance_types = ["t3.medium"]
      min_size = 1
      max_size = 2
      desired_size = 1
    }

    gpu-nodes = {
      name = "gpu-nodes"
      instance_types = ["g4dn.xlarge"]
      ami_type = "AL2023_x86_64_NVIDIA"
      min_size = 0
      max_size = 2
      desired_size = 1
      capacity_type = "ON_DEMAND"
    }
  }

  tags = {
    Environment = "dev"
    Terraform = "true"
  }
}
