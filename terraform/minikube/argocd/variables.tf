variable "argocd_namespace" {
  description = "Namespace для Argo CD"
  type = string
  default = "infra-tools"
}

variable "argocd_chart_version" {
  description = "Версія Helm-чарту Argo CD"
  type = string
  default = "v7.7.5"
}

variable "app_repo_url" {
  description = "Публічний Git-репозиторій з маніфестами"
  type = string
  default = "https://github.com/maximus-ms/goit-argo.git"
}

variable "app_repo_branch" {
  description = "Гілка"
  type = string
  default = "hw-lesson-7"
}

variable "minikube_context" {
  description = "Kubectl context for Minikube"
  type = string
  default = "amd2-minikube"
}

variable "init_argocd_only" {
  description = "Whether to init argocd only (set to false on first run, true on second run)"
  type = bool
  default = false
}
