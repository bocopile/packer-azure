build {
  sources = ["source.azure-arm.ubuntu"]

  provisioner "shell" {
    inline = [
      "echo '[1] 시작: Base Provisioning'",
      "echo 'OS 설정 및 공통 의존성 설치 시작...'"
    ]
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