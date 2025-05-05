#!/bin/bash
set -e

# -----------------------------
# 파라미터 확인
# -----------------------------
if [ "$#" -ne 3 ]; then
  echo "❌ 사용법: $0 <IMAGE_DEFINITION> <IMAGE_VERSION> <SKU>"
  echo "예:     $0 node_vm_ubuntu_24 1.0.0 node-vm"
  exit 1
fi

IMAGE_DEFINITION="$1"
IMAGE_VERSION="$2"
SKU="$3"

# -----------------------------
# 기본 설정
# -----------------------------
RESOURCE_GROUP="devops-resource"
GALLERY_NAME="devops"
LOCATION="koreasouth"
PUBLISHER="bocopile"
OFFER="ubuntu-server"
HYPERV_GEN="V2"

MANAGED_IMAGE_NAME="${IMAGE_DEFINITION}-${IMAGE_VERSION}"

# -----------------------------
# 1. Managed Image ID 확인
# -----------------------------
echo "🔍 Managed Image ID 조회 중..."
MANAGED_IMAGE_ID=$(az image show \
  --name "$MANAGED_IMAGE_NAME" \
  --resource-group "$RESOURCE_GROUP" \
  --query id -o tsv 2>/dev/null)

if [ -z "$MANAGED_IMAGE_ID" ]; then
  echo "❌ Managed Image '$MANAGED_IMAGE_NAME' 을(를) 찾을 수 없습니다. 먼저 Packer로 이미지를 생성하세요."
  exit 1
fi

echo "✅ Managed Image 확인됨: $MANAGED_IMAGE_ID"

# -----------------------------
# 2. 이미지 정의 확인 및 생성
# -----------------------------
if ! az sig image-definition show \
    --gallery-name "$GALLERY_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --gallery-image-definition "$IMAGE_DEFINITION" &> /dev/null; then

  echo "🔧 이미지 정의가 없으므로 생성합니다..."
  az sig image-definition create \
    --resource-group "$RESOURCE_GROUP" \
    --gallery-name "$GALLERY_NAME" \
    --gallery-image-definition "$IMAGE_DEFINITION" \
    --publisher "$PUBLISHER" \
    --offer "$OFFER" \
    --sku "$SKU" \
    --os-type Linux \
    --hyper-v-generation "$HYPERV_GEN"
else
  echo "✅ 이미지 정의가 이미 존재합니다."
fi

# -----------------------------
# 3. 이미지 버전 존재 시 등록 스킵
# -----------------------------
if az sig image-version show \
    --resource-group "$RESOURCE_GROUP" \
    --gallery-name "$GALLERY_NAME" \
    --gallery-image-definition "$IMAGE_DEFINITION" \
    --gallery-image-version "$IMAGE_VERSION" &> /dev/null; then

  echo "⚠️ 이미지 버전 '$IMAGE_VERSION' 이(가) 이미 존재합니다. 등록을 스킵합니다."
else
  # -----------------------------
  # 4. 이미지 버전 등록
  # -----------------------------
  echo "📦 이미지 버전 등록 중..."
  az sig image-version create \
    --resource-group "$RESOURCE_GROUP" \
    --gallery-name "$GALLERY_NAME" \
    --gallery-image-definition "$IMAGE_DEFINITION" \
    --gallery-image-version "$IMAGE_VERSION" \
    --managed-image "$MANAGED_IMAGE_ID" \
    --location "$LOCATION" \
    --target-regions "$LOCATION"

  echo "✅ 이미지 버전 등록 완료: $IMAGE_VERSION"
fi

# -----------------------------
# 5. Managed Image 삭제
# -----------------------------
echo "🧹 Managed Image 삭제 중: $MANAGED_IMAGE_NAME"
az image delete \
  --name "$MANAGED_IMAGE_NAME" \
  --resource-group "$RESOURCE_GROUP"

echo "✅ Managed Image 삭제 완료"
