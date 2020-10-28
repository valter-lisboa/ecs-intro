variable "cluster_name" {
  default = "tdc-recife-2020-fargate-demo"
}
variable "lb_name" {
  default = "tdc-recife-2020-fargate-demo"
}
variable "app_name" {
  default = "nginx"
}
variable "app_image" {
  default = "nginx:alpine"
}
variable "environment" {
  default = "development"
}
