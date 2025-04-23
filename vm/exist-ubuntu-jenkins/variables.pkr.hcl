variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}
variable "subscription_id" {}

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
  default = "jenkins_vm_ubuntu_24"
}

variable "source_image_version" {
  default = "1.0.3"
}

variable "image_version" {
  default = "1.0.4"
}

variable "os_type" {
  default = "Linux"
}

variable "gallery_rg" {
  default = "devops-resource"
}