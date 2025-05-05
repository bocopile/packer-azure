

build {
  sources = ["source.azure-arm.ubuntu"]

  provisioner "shell" {
    inline = ["echo 'Provisioning started...'"]
  }

  provisioner "shell" {
    script = "scripts/setup.sh"
  }

  provisioner "shell" {
    script = "scripts/install-promtail.sh"
  }

}
