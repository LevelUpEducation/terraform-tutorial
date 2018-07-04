terraform {
  backend "s3" {
    bucket = "stefan-terraform-demo"
    key    = "network/terraform.tfstate"
    region = "us-east-1"
  }
}

locals {
  regions = {
    staging    = "us-west-1"
    production = "us-east-1"
  }

  instance_count = {
    staging    = "1"
    production = "2"
  }
}

module "backend" {
  source           = "./Backend"
  region           = "${local.regions[terraform.workspace]}"
  number_instances = "${local.instance_count[terraform.workspace]}"
}

module "frontend" {
  source           = "./Frontend"
  region           = "${local.regions[terraform.workspace]}"
  number_instances = "${local.instance_count[terraform.workspace]}"
}
