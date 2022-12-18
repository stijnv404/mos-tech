resource "kubernetes_deployment" "app" {
    
  metadata {
    name = var.app
    labels = {
      app = var.app
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.app
      }
    }

    template {

      metadata {
        labels = {
          app = var.app
        }
      }

      spec {

        dynamic "volume" {
          for_each = var.add_mount ? [1] : []
          content {
            name = var.app
            
            persistent_volume_claim {
              claim_name = kubernetes_persistent_volume_claim.app[0].metadata.0.name
            }
          }
        }

        container {
          image = "${var.docker_image_prefix}/${var.docker_image_name}"
          name  = var.app

          port {
            name           = "webport"
            container_port = var.web_port
          }

          dynamic "volume_mount" {
            for_each = var.add_mount ? [1] : []
            content {
              mount_path = var.mount_path
              name = var.app
            }
          }
        }

      }

    }

  }

}

resource "kubernetes_persistent_volume_claim" "app" {

  count = var.add_mount ? 1 : 0

  metadata {
    name = var.app
  }

  spec {
    volume_name = "${kubernetes_persistent_volume.app[0].metadata.0.name}"
    access_modes = kubernetes_persistent_volume.app[0].spec.0.access_modes
    resources {
      requests = {
        storage = kubernetes_persistent_volume.app[0].spec.0.capacity.storage
      }
    }
  }
}

resource "kubernetes_persistent_volume" "app" {

  count = var.add_mount ? 1 : 0
  
  metadata {
    name = var.app
  }

  spec {
    capacity = {
      storage = "${google_compute_disk.app[0].size}Gi"
    }
    access_modes = ["ReadWriteOnce"]
    storage_class_name = "standard-rwo"
    persistent_volume_source {
      gce_persistent_disk {
        pd_name = var.app
        fs_type = "ext4"
      }
    }
  }
}

resource "google_compute_disk" "app" {

  count = var.add_mount ? 1 : 0

  lifecycle {
    ignore_changes = [
      labels
    ]
  }

  name  = var.app
  type  = "pd-ssd"
  project = var.project
  zone  = var.zone
  size = var.mount_volume_gb
}