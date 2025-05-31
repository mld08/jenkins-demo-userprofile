output "postgres_service_name" {
  value = kubernetes_service.postgres.metadata[0].name
}

output "postgres_pvc_name" {
  value = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
}
