output "argocd_login" {
  description = "Prints default login for ArgoCD (default is 'admin')"
  value       = "admin"
}

output "argocd_password" {
  description = "Prints initial admin password for ArgoCD"
  value       = "kubectl -n ${var.argocd_namespace} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d ; echo"
}

output "argocd_port_forward" {
  description = "Prints port forward command for ArgoCD"
  value       = "kubectl port-forward svc/argocd-server -n ${var.argocd_namespace} 8080:80"
}
