variable "project" {}
variable "zone" {}
variable "app" {}
variable "docker_image_prefix" {}
variable "docker_image_name" {}

variable "web_port" {
  type    = number
}

variable "add_mount" {
  type    = bool
  default = false
}

variable "mount_path" {
  default = ""
}

variable "mount_volume_gb" {
  type    = number
  default = 10
}