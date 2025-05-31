variable "name" {
  type        = string
  description = "Nom du déploiement et du service"
  default     = "frontend"
}

variable "image" {
  type        = string
  description = "Image Docker à déployer"
}

variable "replicas" {
  type    = number
  default = 2
}

variable "container_port" {
  type    = number
  default = 80
}

variable "node_port" {
  type        = number
  description = "NodePort personnalisé (entre 30000-32767)"
  default     = 30517
}

variable "resources" {
  type = object({
    requests = object({
      memory = string
      cpu    = string
    })
    limits = object({
      memory = string
      cpu    = string
    })
  })
  default = {
    requests = {
      memory = "128Mi"
      cpu    = "250m"
    }
    limits = {
      memory = "256Mi"
      cpu    = "500m"
    }
  }
}
