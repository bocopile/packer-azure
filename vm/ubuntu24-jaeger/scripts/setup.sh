#!/bin/bash
set -e

JAEGER_VERSION="1.68.0"

# 1. Create jaeger user
sudo useradd --no-create-home --shell /bin/false jaeger || true

# 2. Install dependencies
sudo apt-get update
sudo apt-get install -y curl tar

# 3. Download the official tar.gz
cd /tmp
curl -LO https://github.com/jaegertracing/jaeger/releases/download/v${JAEGER_VERSION}/jaeger-${JAEGER_VERSION}-linux-amd64.tar.gz

# 4. Extract only the "jaeger-all-in-one" binary
tar -zxvf jaeger-${JAEGER_VERSION}-linux-amd64.tar.gz
sudo mv jaeger-${JAEGER_VERSION}-linux-amd64/jaeger-all-in-one /usr/local/bin/jaeger
sudo chmod +x /usr/local/bin/jaeger
sudo chown jaeger:jaeger /usr/local/bin/jaeger

# 5. Create systemd unit
sudo tee /etc/systemd/system/jaeger.service > /dev/null <<EOF
[Unit]
Description=Jaeger All-in-One
After=network.target

[Service]
User=jaeger
Group=jaeger
ExecStart=/usr/local/bin/jaeger \
  --collector.otlp.enabled=true \
  --collector.otlp.grpc.host-port=0.0.0.0:4317 \
  --collector.zipkin.host-port=:9411 \
  --collector.http-port=14268 \
  --query.base-path=/jaeger \
  --query.port=16686
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

# 6. Enable and start
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable jaeger
sudo systemctl start jaeger
