packer {
  required_version = ">= 1.10.0"

  required_plugins {
    azure-arm = {
      version = ">= 1.7.0"
      source  = "github.com/hashicorp/azure"
    }
  }
}