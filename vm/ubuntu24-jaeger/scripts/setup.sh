#!/bin/bash
set -e

JAEGER_VERSION="1.68.0"

echo "▶ [1] jaeger 사용자 생성"
sudo useradd --no-create-home --shell /bin/false jaeger || true

echo "▶ [2] 필수 패키지 설치"
sudo apt-get update
sudo apt-get install -y curl tar

echo "▶ [3] Jaeger 바이너리 다운로드"
cd /tmp
curl -LO https://github.com/jaegertracing/jaeger/releases/download/v${JAEGER_VERSION}/jaeger-${JAEGER_VERSION}-linux-amd64.tar.gz

echo "▶ [4] 압축 해제 및 바이너리 설치"
tar -zxvf jaeger-${JAEGER_VERSION}-linux-amd64.tar.gz
sudo mv jaeger-${JAEGER_VERSION}-linux-amd64/jaeger-all-in-one /usr/local/bin/jaeger
sudo chmod +x /usr/local/bin/jaeger
sudo chown jaeger:jaeger /usr/local/bin/jaeger

echo "▶ [5] 로그 디렉토리 생성"
sudo mkdir -p /var/log/jaeger
sudo chown -R jaeger:jaeger /var/log/jaeger

echo "▶ [6] Wrapper 스크립트 생성"
sudo tee /usr/local/bin/jaeger-wrapper.sh > /dev/null <<'EOF'
#!/bin/bash
exec /usr/local/bin/jaeger "$@" >> /var/log/jaeger/jaeger.log 2>&1
EOF
sudo chmod +x /usr/local/bin/jaeger-wrapper.sh
sudo chown jaeger:jaeger /usr/local/bin/jaeger-wrapper.sh

echo "▶ [7] 설정파일: /etc/default/jaeger"
sudo tee /etc/default/jaeger > /dev/null <<EOF
JAEGER_LOG_LEVEL=debug
JAEGER_SAMPLER_TYPE=const
JAEGER_SAMPLER_PARAM=1
EOF

echo "▶ [8] systemd 서비스 등록"
sudo tee /etc/systemd/system/jaeger.service > /dev/null <<EOF
[Unit]
Description=Jaeger All-in-One
After=network.target

[Service]
User=jaeger
Group=jaeger
EnvironmentFile=/etc/default/jaeger
ExecStart=/usr/local/bin/jaeger-wrapper.sh \\
  --collector.otlp.enabled=true \\
  --collector.otlp.grpc.host-port=0.0.0.0:4317 \\
  --collector.zipkin.host-port=:9411 \\
  --query.base-path=/jaeger
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

echo "▶ [9] systemd 시작"
sudo systemctl daemon-reload
sudo systemctl enable jaeger
sudo systemctl start jaeger

