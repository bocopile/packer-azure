variable "resource_group" {
  default = "devops-resource"
}
variable "location" {
  default = "koreasouth"
}
variable "gallery_name" {
  default = "devops"
}
variable "image_name" {
  default = "prometheus_vm_ubuntu_24"
}
variable "image_version" {
  default = "1.0.0"
}
# OS 이미지 정보 변수화
variable "os_type" {
  default = "Linux"
}
variable "os_publisher" {
  default = "Canonical"
}
variable "os_offer" {
  default = "ubuntu-24_04-lts"
}
variable "os_sku" {
  default = "server"
}
variable "os_version" {
  default = "latest"
}

variable "client_id" {
  sensitive = true
}
variable "client_secret" {
  sensitive = true
}
variable "tenant_id" {
  sensitive = true
}
variable "subscription_id" {
  sensitive = true
}

