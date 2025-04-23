build {
  name    = "jenkins-vm-ubuntu-update"
  sources = ["source.azure-arm.jenkins"]

  provisioner "shell" {
    script = "./scripts/install-packer.sh"
  }
}