resource "kubernetes_ingress_v1" "this" {
  metadata {
    name = var.name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = var.rewrite_target
    }
  }

  spec {
    rule {
      host = var.frontend_host

      http {
        path {
          path     = var.frontend_path
          path_type = var.path_type

          backend {
            service {
              name = var.frontend_service_name
              port {
                number = var.frontend_service_port
              }
            }
          }
        }
      }
    }

    rule {
      host = var.backend_host

      http {
        path {
          path     = var.backend_path
          path_type = var.path_type

          backend {
            service {
              name = var.backend_service_name
              port {
                number = var.backend_service_port
              }
            }
          }
        }
      }
    }
  }
}
