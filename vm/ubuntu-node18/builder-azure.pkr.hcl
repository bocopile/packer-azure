

build {
  sources = ["source.azure-arm.ubuntu"]

  provisioner "shell" {
    inline = ["echo 'Provisioning started...'"]
  }

  provisioner "shell" {
    script = "scripts/setup.sh"
    environment_vars = [
      "NEXUS_ID=${var.nexus_id}",
      "NEXUS_PASSWORD=${var.nexus_password}",
      "NPM_REGISTRY=${var.npm_registry}",
      "VERSION=${var.version}"
    ]
  }
}
