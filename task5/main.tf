module "web_with_mount_mostechstijnm" {
  source = "./web_with_mount"

  project = var.project
  zone = var.zone
  app = "mos-tech-stijnm"
  docker_image_prefix = var.docker_image_prefix
  docker_image_name = "mos-tech-stijnm"

  web_port = 8123

  add_mount = true
  mount_path = "/app/uploads"
}

module "web_with_mount_nginxhello" {
  source = "./web_with_mount"

  project = var.project
  zone = var.zone
  app = "nginx-hello"
  docker_image_prefix = "nginxdemos"
  docker_image_name = "hello"

  web_port = 80
}