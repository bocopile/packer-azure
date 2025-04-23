source "azure-arm" "ubuntu" {
  client_id         = var.client_id
  client_secret     = var.client_secret
  tenant_id         = var.tenant_id
  subscription_id   = var.subscription_id

  managed_image_name                = "${var.image_name}-${var.version}"
  managed_image_resource_group_name = var.resource_group
  location                          = var.location

  os_type         = var.os_type
  image_publisher = var.os_publisher
  image_offer     = var.os_offer
  image_sku       = var.os_sku
  image_version   = var.os_version

  ssh_username = "bocopile"

  # 이미지 생성 후 Azure Compute Gallery 업로드는 별도 처리 필요
  vm_size = "Standard_E2bds_v5"
}