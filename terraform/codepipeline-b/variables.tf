variable "docker_login_username" {
  type = string
}

variable "docker_login_password" {
  type      = string
  sensitive = true
}
