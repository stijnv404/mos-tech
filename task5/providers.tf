# Retrieve an access token as the Terraform runner
data "google_client_config" "provider" {}

data "google_container_cluster" "main" {
  project  = var.project
  name     = var.cluster
  location = var.zone
}

provider "kubernetes" {
  host  = "https://${data.google_container_cluster.main.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    data.google_container_cluster.main.master_auth[0].cluster_ca_certificate,
  )
}