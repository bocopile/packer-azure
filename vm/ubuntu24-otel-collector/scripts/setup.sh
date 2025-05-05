#!/bin/bash
set -e

OTEL_VERSION="0.125.0"

# 시스템 업데이트 및 wget 설치
sudo apt-get update
sudo apt-get install -y wget

# otelcol 유저 생성 (이미 존재하면 생략)
if ! id "otelcol" &>/dev/null; then
  sudo useradd --no-create-home --shell /bin/false otelcol
fi

# .deb 파일 다운로드 및 설치
cd /tmp
wget https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${OTEL_VERSION}/otelcol_${OTEL_VERSION}_linux_amd64.deb
sudo dpkg -i otelcol_${OTEL_VERSION}_linux_amd64.deb

# Collector 설정 디렉토리 생성 및 설정 복사
sudo mkdir -p /etc/otel-collector
sudo cp /tmp/otel-collector-config.yaml /etc/otel-collector/config.yaml
sudo chown -R otelcol:otelcol /etc/otel-collector

# 서비스 재시작 (설치된 systemd 유닛 사용)
sudo systemctl daemon-reload
sudo systemctl enable otelcol
sudo systemctl restart otelcol
