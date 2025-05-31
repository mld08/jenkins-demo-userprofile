variable "name" {
  type        = string
  description = "Nom de l'application et des ressources"
  default     = "backend"
}

variable "image" {
  type        = string
  description = "Nom de l'image Docker à déployer"
}

variable "replicas" {
  type        = number
  default     = 2
}

variable "container_port" {
  type        = number
  default     = 8000
}

variable "env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Liste des variables d'environnement"
}

variable "node_port" {
  type        = number
  description = "NodePort personnalisé (entre 30000-32767)"
  default     = 30243
}
