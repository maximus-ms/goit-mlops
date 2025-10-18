terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">= 2.29, < 3.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">= 2.13, < 3.0"
    }
  }
}

# Kubectl configuration for Minikube
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "amd2-minikube"
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "amd2-minikube"
  }
}