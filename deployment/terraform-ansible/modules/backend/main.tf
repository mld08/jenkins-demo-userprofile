resource "kubernetes_deployment" "backend" {
  metadata {
    name = var.name
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

          dynamic "env" {
            for_each = var.env_vars
            content {
              name  = env.value.name
              value = env.value.value
            }
          }

          port {
            container_port = var.container_port
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "backend" {
  metadata {
    name = var.name
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
    }
  }
}
