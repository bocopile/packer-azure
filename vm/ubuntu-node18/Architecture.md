

```bash
packer-ubuntu-node18/
├── variables.pkr.hcl
├── versions.pkr.hcl
├── builder-azure.pkr.hcl
├── provisioner-node18.pkr.hcl
└── scripts/
└── setup.sh
```

# packer 실행

```bash

# packer 초기화
packer init .


# ~/.zshrc -> secrets 으로 변경

cat <<EOF > secrets.auto.pkrvars.hcl
client_id       = "${ARM_CLIENT_ID}"
client_secret   = "${ARM_CLIENT_SECRET}"
tenant_id       = "${ARM_TENANT_ID}"
subscription_id = "${ARM_SUBSCRIPTION_ID}"

nexus_id        = "${NEXUS_ID}"
nexus_password  = "${NEXUS_PASSWORD}"
npm_registry    = "${NPM_REGISTRY}"
version         = "${VERSION}"
EOF

# validate 검사
packer validate .

# build 진행
PACKER_LOG=1 PACKER_LOG_PATH=packer-debug.log packer build .

# VM image -> Azure Compute Gallary upload 진행

chmod +x ./scripts/upload-compute-gallery.sh
./scripts/upload-compute-gallery.sh <IMAGE_DEFINITION> <IMAGE_VERSION>
./scripts/upload-compute-gallery.sh node_vm_ubuntu_24 1.0.0
```