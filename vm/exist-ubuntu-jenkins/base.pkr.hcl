source "azure-arm" "jenkins" {
  client_id                   = var.client_id
  client_secret               = var.client_secret
  tenant_id                   = var.tenant_id
  subscription_id             = var.subscription_id

  location        = var.location
  vm_size         = "Standard_B1s"
  os_type         = var.os_type

  // Use existing SIG image as build source
  shared_image_gallery {
    subscription    = var.subscription_id
    resource_group  = var.gallery_rg
    gallery_name    = var.gallery_name
    image_name      = var.image_name
    image_version   = var.source_image_version
  }

  // Publish the new version back to SIG
  shared_image_gallery_destination {
    subscription         = var.subscription_id
    resource_group       = var.gallery_rg
    gallery_name         = var.gallery_name
    image_name           = var.image_name
    image_version        = var.image_version
    storage_account_type = "Standard_LRS"
    target_region {
      name     = var.location
      replicas = 1
    }
  }

  // Optional: extend timeout for large operations
  shared_image_gallery_timeout = "90m"
}