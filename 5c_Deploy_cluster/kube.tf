module "kubernetes" {
  source = "./kubernetes"
  region = "us-east1"

  project_id_map = {
    default = "stefan-terraform-demo"
  }
}

output "connection-command" {
  value = "${module.kubernetes.connect-string}"
}
