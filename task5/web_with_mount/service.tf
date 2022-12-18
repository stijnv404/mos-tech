resource "kubernetes_service" "app" {

  lifecycle {
    ignore_changes = [
      metadata.0.annotations
    ]
  }

  metadata {
    name = var.app
  }

  spec {

    selector = {
      app = kubernetes_deployment.app.metadata.0.labels.app
    }

    port {
      port        = 80
      target_port = var.web_port
    }

    type = "LoadBalancer"
  }

}