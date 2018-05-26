variable "project_id_map" {
  default = {
    default = "my-project"
  }

  type = "map"
}

variable "region" {}

variable "oauth_scopes" {
  type = "list"

  default = [
    "https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/service.management",
    "https://www.googleapis.com/auth/servicecontrol",
  ]
}

variable "instance_size" {
  type = "map"

  default = {
    default = "n1-standard-1"
  }
}

variable "disk_size" {
  type = "map"

  default = {
    default = 200
  }
}

variable "node_version" {
  default = "1.9.6-gke.1"
}

variable "dependency_id" {
  description = "This variable is unused. It is here simple as a work around to enforce module dependancy. Github issue 10462, in the provider repo"
  default     = ""
}
