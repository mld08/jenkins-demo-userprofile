terraform {
    required_providers {
        kubernetes = {
        source  = "hashicorp/kubernetes"
        version = "~> 2.25"
        }
    }
    
    required_version = ">= 1.2.0"
}

provider "kubernetes" {
    config_context = "minikube"
    config_path = "~/.kube/config"
}

module "backend" {
  source = "./modules/backend"

  image    = "mldiop08/userprofile_backend:latest"
  env_vars = [
    {
      name  = "DJANGO_SETTINGS_MODULE"
      value = "odc.settings"
    },
    {
      name  = "POSTGRES_HOST"
      value = "postgres"
    },
    {
      name  = "POSTGRES_DB"
      value = "odcdb"
    }
  ]
}

module "frontend" {
  source = "./modules/frontend"

  image       = "mldiop08/userprofile_frontend:latest"
  node_port   = 30517
}

module "postgres" {
  source = "./modules/postgres"

  postgres_user     = "odc"
  postgres_password = "odc123"
  postgres_db       = "odcdb"
}

// Ansible post-deployment
// This resource will run the Ansible playbook after the Kubernetes resources are created
resource "null_resource" "ansible_postdeploy" {
  depends_on = [module.frontend, module.backend, module.postgres]

provisioner "local-exec" {
    command = "ansible-playbook -i ansible/inventory.ini ansible/playbook.yaml"
  }
}