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
  default = "node_vm_ubuntu_24"
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


variable "client_id" {}
variable "client_secret" {
  sensitive = true
}
variable "tenant_id" {}
variable "subscription_id" {}

variable "nexus_id" {}
variable "nexus_password" {
  sensitive = true
}
variable "npm_registry" {}
variable "version" {}
