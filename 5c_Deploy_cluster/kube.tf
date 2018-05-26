module "kubernetes" {
  source = "./kubernetes"
  region = "us-east1"

  project_id_map = {
    default = "stefan-personal-196107"
  }
}

output "connection-command" {
  value = "${module.kubernetes.connect-string}"
}
