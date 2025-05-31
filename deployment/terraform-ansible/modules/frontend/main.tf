resource "kubernetes_deployment" "frontend" {
  metadata {
    name = "${var.name}-deployment"
    labels = {
      app = var.name
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        container {
          name  = "${var.name}-container"
          image = var.image
          image_pull_policy = "Always"

          port {
            container_port = var.container_port
          }

          resources {
            requests = var.resources.requests
            limits   = var.resources.limits
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "frontend" {
  metadata {
    name = "${var.name}-service"
  }

  spec {
    selector = {
      app = var.name
    }

    type = "NodePort"

    port {
      port        = var.container_port
      target_port = var.container_port
      node_port   = var.node_port
      protocol    = "TCP"
    }
  }
}
