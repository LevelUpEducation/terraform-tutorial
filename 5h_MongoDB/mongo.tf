provider "helm" {}

resource "helm_release" "mongo" {
  name  = "mongo"
  chart = "stable/mongodb-replicaset"

  set {
    name  = "auth.adminUser"
    value = "foo"
  }

  set {
    name  = "auth.adminPassword"
    value = "asdfgh"
  }
}
