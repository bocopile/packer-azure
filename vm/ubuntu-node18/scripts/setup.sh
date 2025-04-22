#!/bin/bash

set -e

# Node.js 18 설치
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# 기타 설치
sudo apt-get install -y net-tools curl

# 환경 변수 불러오기
source /home/bocopile/.bashrc

# 프로젝트 다운로드
wget --user="${NEXUS_ID}" --password="${NEXUS_PASSWORD}" \
  "http://${NPM_REGISTRY}/repository/express-winston/express-winston/-/express-winston-${VERSION}.tgz" \
  -O /home/bocopile/express-winston.tgz

# 압축 해제 및 설치
cd /home/bocopile
mkdir -p app && tar -xzf express-winston.tgz -C app --strip-components=1

# 서비스 등록
sudo tee /etc/systemd/system/app.service > /dev/null <<EOF
[Unit]
Description=Express Winston Node App
After=network.target

[Service]
User=bocopile
ExecStart=/usr/bin/node /home/bocopile/app/index.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl enable app.service

# node 모듈 권한 부여
sudo chmod -R 755 /usr/lib/node_modules/
sudo chown -R bocopile:bocopile /usr/lib/node_modules/