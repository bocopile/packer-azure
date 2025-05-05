build {
  sources = ["source.azure-arm.ubuntu"]

  provisioner "shell" {
    inline = ["echo 'Provisioning started...'"]
  }

  provisioner "file" {
    source      = "setting/otel-collector-config.yaml"
    destination = "/tmp/otel-collector-config.yaml"
  }

  provisioner "shell" {
    script = "scripts/setup.sh"
  }

  provisioner "shell" {
    script = "scripts/install-node-exporter.sh"
  }

  provisioner "shell" {
    script = "scripts/install-promtail.sh"
  }
}
