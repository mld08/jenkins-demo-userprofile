variable "name" {
  description = "Name of the ingress"
  type        = string
}

variable "rewrite_target" {
  description = "Rewrite target for nginx ingress"
  type        = string
  default     = "/"
}

variable "frontend_host" {
  type        = string
  description = "Frontend host"
}

variable "frontend_path" {
  type        = string
  default     = "/"
}

variable "frontend_service_name" {
  type        = string
  description = "Frontend service name"
}

variable "frontend_service_port" {
  type        = number
  default     = 80
}

variable "backend_host" {
  type        = string
  description = "Backend host"
}

variable "backend_path" {
  type        = string
  default     = "/"
}

variable "backend_service_name" {
  type        = string
  description = "Backend service name"
}

variable "backend_service_port" {
  type        = number
  default     = 8000
}

variable "path_type" {
  type        = string
  default     = "Prefix"
}
