data "google_compute_zones" "available" {}

data "google_container_engine_versions" "available" {
  zone = "${local.primary_zone}"
}

locals {
  default_name = "${var.project_id_map[terraform.workspace]}-cluster"
  name         = "${local.default_name}"
  primary_zone = "${data.google_compute_zones.available.names[0]}"
  project      = "${var.project_id_map[terraform.workspace]}"

  pre_calc_additional_zones = [
    "${data.google_compute_zones.available.names[1]}",
    "${data.google_compute_zones.available.names[2]}",
  ]

  additional_zones = "${compact(local.pre_calc_additional_zones)}"
}

resource "null_resource" "start" {
  triggers {
    depends_id = "${var.dependency_id}"
  }
}

resource "google_container_cluster" "primary" {
  name               = "${local.name}"
  project            = "${local.project}"
  zone               = "${local.primary_zone}"
  node_version       = "${var.node_version}"
  min_master_version = "${var.node_version}"
  description        = "Kubernetes cluster"

  additional_zones = ["${local.additional_zones}"]

  lifecycle {
    ignore_changes = ["node_pool"]
  }

  # Empty node pool
  node_pool {
    name = "unused-default-pool"
  }

  depends_on = ["null_resource.start"]
}

resource "google_container_node_pool" "default" {
  name               = "${local.name}-pool"
  zone               = "${local.primary_zone}"
  cluster            = "${google_container_cluster.primary.name}"
  initial_node_count = 1

  management = {
    auto_repair  = true
    auto_upgrade = false
  }

  autoscaling = {
    min_node_count = 1
    max_node_count = 10
  }

  node_config {
    # Optimal cost performance I/O
    disk_size_gb = "${var.disk_size[terraform.workspace]}"
    machine_type = "${var.instance_size[terraform.workspace]}"
    oauth_scopes = "${var.oauth_scopes}"
  }

  depends_on = ["google_container_cluster.primary"]
}

# The following outputs allow authentication and connectivity to the GKE Cluster.
output "connect-string" {
  value = "${join(
    " ", 
    list(
      "gcloud container clusters get-credentials", 
      local.name, 
      "--zone", 
      local.primary_zone, 
      "--project", 
      local.project
    )
  )}"
}

output "primary_zone" {
  value = "${google_container_cluster.primary.*.zone}"
}

output "kubernetes-version" {
  value = "${data.google_container_engine_versions.available.latest_node_version}"
}
