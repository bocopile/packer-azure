#!/bin/bash
set -e

LOKI_VERSION="2.9.4"

# Create Loki user
sudo useradd --no-create-home --shell /bin/false loki

# Create directories
sudo mkdir -p /etc/loki /var/lib/loki
sudo chown loki:loki /etc/loki /var/lib/loki

# Download Loki binary
cd /tmp
curl -LO "https://github.com/grafana/loki/releases/download/v${LOKI_VERSION}/loki-linux-amd64.zip"
sudo apt-get install -y unzip
unzip loki-linux-amd64.zip
chmod +x loki-linux-amd64
sudo mv loki-linux-amd64 /usr/local/bin/loki
sudo chown loki:loki /usr/local/bin/loki

# Copy config
sudo cp /tmp/loki-config.yaml /etc/loki/config.yaml
sudo chown loki:loki /etc/loki/config.yaml

# Create systemd unit
sudo tee /etc/systemd/system/loki.service > /dev/null <<EOF
[Unit]
Description=Grafana Loki
After=network.target

[Service]
User=loki
Group=loki
Type=simple
ExecStart=/usr/local/bin/loki -config.file=/etc/loki/config.yaml
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# Enable and start
sudo systemctl daemon-reload
sudo systemctl enable loki
sudo systemctl start loki
