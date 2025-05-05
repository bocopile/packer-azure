

```bash
packer-ubuntu-node18/
├── variables.pkr.hcl  # 파라미터 세팅
├── versions.pkr.hcl   # Packer, Plugin 최소 버전 체크
├── builder-azure.pkr.hcl # VM 생성시 설치 할 SW를 입력
└── scripts/setup.sh
```

# Packer - RabbitMQ 실행

```bash

# packer 초기화
packer init .


# ~/.zshrc -> secrets 으로 변경

cat <<EOF > secrets.auto.pkrvars.hcl
client_id       = "${ARM_CLIENT_ID}"
client_secret   = "${ARM_CLIENT_SECRET}"
tenant_id       = "${ARM_TENANT_ID}"
subscription_id = "${ARM_SUBSCRIPTION_ID}"

EOF 

# validate 검사
packer validate .

# build 진행 
PACKER_LOG=1 PACKER_LOG_PATH=packer-debug.log packer build .

# VM image -> Azure Compute Gallary upload 진행
../upload-gallery/upload-compute-gallery.sh <IMAGE_DEFINITION> <IMAGE_VERSION> <SKU>
../upload-gallery/upload-compute-gallery.sh prometheus_vm_ubuntu_24 1.0.0 prometheus-vm
```