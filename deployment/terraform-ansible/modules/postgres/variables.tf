variable "name" {
  type        = string
  description = "Nom du déploiement, service, pvc, etc."
  default     = "postgres"
}

variable "image" {
  type        = string
  description = "Image Docker PostgreSQL"
  default     = "postgres:latest"
}

variable "replicas" {
  type    = number
  default = 1
}

variable "postgres_user" {
  type = string
}

variable "postgres_password" {
  type = string
}

variable "postgres_db" {
  type = string
}

variable "storage_size" {
  type    = string
  default = "1Gi"
}

