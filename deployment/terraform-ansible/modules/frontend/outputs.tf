output "service_name" {
  value = kubernetes_service.frontend.metadata[0].name
}

output "deployment_name" {
  value = kubernetes_deployment.frontend.metadata[0].name
}
