provider kubernetes {
  # leave blank to pickup config from kubectl config of local system
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx"
  }

  spec {
    selector {
      app = "nginx"
    }

    template {
      metadata {
        labels {
          app = "nginx"
        }
      }

      spec {
        container {
          image = "nginx"
          name  = "app"

          resources {
            requests {
              memory = "256Mi"
              cpu    = "100m"
            }

            limits {
              memory = "1Gi"
              cpu    = "500m"
            }
          }

          readiness_probe {
            http_get {
              path = "/"
              port = "80"
            }

            initial_delay_seconds = 10
            period_seconds        = 10
          }

          liveness_probe {
            http_get {
              path = "/"
              port = "80"
            }

            initial_delay_seconds = 120
            period_seconds        = 15
          }

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "example" {
  metadata {
    name = "terraform-nginx-example"
  }

  spec {
    selector {
      app = "nginx"
    }

    session_affinity = "ClientIP"

    port {
      port = 80
    }

    type = "LoadBalancer"
  }
}

output "lb_ip" {
  value = "${kubernetes_service.example.load_balancer_ingress.0.ip}"
}
