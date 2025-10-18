resource "kubernetes_namespace" "argo" {
  metadata {
    name = var.argocd_namespace
  }
}


# Встановлення Argo CD через офіційний Helm-чарт
resource "helm_release" "argo" {
  name       = "argocd"
  namespace  = kubernetes_namespace.argo.metadata[0].name


  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version


  recreate_pods = true
  replace       = true


  values = [file("${path.module}/values/argocd-values.yaml")]
}


resource "kubernetes_manifest" "namespaces_appset" {
  # Only deploy this resource if init_argocd_only is set to false
  count = var.init_argocd_only ? 0 : 1
  
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind = "ApplicationSet"
    metadata = {
      name = "namespaces-appset"
      namespace = var.argocd_namespace
    }
    spec = {
      generators = [{
        git = {
          repoURL = var.app_repo_url
          revision = var.app_repo_branch
          directories = [{ path = "namespace/*" }]
        }
      }]
      template = {
        metadata = {
          name = "ns-{{path.basename}}"
          namespace = var.argocd_namespace
        }
        spec = {
          project = "default"
          source = {
            repoURL = var.app_repo_url
            targetRevision = var.app_repo_branch
            path = "{{path}}"
            directory = { recurse = true }  # читати підкаталоги (apps/, configmaps/, secrets/)
          }
          destination = {
            server = "https://kubernetes.default.svc"
            namespace = "{{path.basename}}"  # application / infra-tools / ...
          }
          syncPolicy = {
            automated = { prune = true, selfHeal = true }
            syncOptions = ["CreateNamespace=true"]
          }
          revisionHistoryLimit = 2
        }
      }
    }
  }

  depends_on = [helm_release.argo]
}
