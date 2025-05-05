#!/bin/bash
set -e

PROMTAIL_VERSION="2.9.2"

sudo useradd --no-create-home --shell /bin/false promtail || true

sudo apt-get install -y net-tools unzip

curl -LO https://github.com/grafana/loki/releases/download/v${PROMTAIL_VERSION}/promtail-linux-amd64.zip
unzip promtail-linux-amd64.zip
sudo mv promtail-linux-amd64 /usr/local/bin/promtail
sudo chmod +x /usr/local/bin/promtail
rm promtail-linux-amd64.zip

# Promtail 설정 (기본 /log 경로를 수집)
sudo tee /etc/promtail-config.yaml > /dev/null <<EOF
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki.bocopile.io:3100/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          host: \${HOSTNAME}
          __path__: /log/\${HOSTNAME}/*.log
EOF

# systemd 서비스 등록
sudo tee /etc/systemd/system/promtail.service  > /dev/null <<EOF
[Unit]
Description=Promtail log shipping agent
After=network.target

[Service]
User=promtail
ExecStart=/usr/local/bin/promtail -config.file=/etc/promtail-config.yaml
Restart=always

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable promtail
sudo systemctl start promtail