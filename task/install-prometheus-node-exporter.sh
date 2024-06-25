#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/task/install-prometheus-node-exporter.sh)"

# Include colors
source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/lib/cli-colors.sh)

# Get the latest version of Prometheus Node Exporter from GitHub
echo "${YELLOW}Fetching the latest version of Prometheus Node Exporter...${NC}"
latest_version=$(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')

if [ -z "$latest_version" ]; then
    echo "${RED}Failed to fetch the latest version of Prometheus Node Exporter.${NC}"
    exit 1
fi

echo "${GREEN}Latest version is ${latest_version}.${NC}"

# Define the download URL and file name
download_url="https://github.com/prometheus/node_exporter/releases/download/${latest_version}/node_exporter-${latest_version}.linux-amd64.tar.gz"
file_name="node_exporter-${latest_version}.linux-amd64.tar.gz"

# Download the latest version of Prometheus Node Exporter
echo "${YELLOW}Downloading Prometheus Node Exporter...${NC}"
wget -q $download_url -O $file_name

if [ $? -ne 0 ]; then
    echo "${RED}Failed to download Prometheus Node Exporter.${NC}"
    exit 1
fi

# Extract the downloaded tarball
echo "${YELLOW}Extracting Prometheus Node Exporter...${NC}"
tar -xzf $file_name

if [ $? -ne 0 ]; then
    echo "${RED}Failed to extract Prometheus Node Exporter.${NC}"
    exit 1
fi

# Move the binary to /usr/local/bin
echo "${YELLOW}Installing Prometheus Node Exporter...${NC}"
sudo mv node_exporter-${latest_version}.linux-amd64/node_exporter /usr/local/bin/

if [ $? -ne 0 ]; then
    echo "${RED}Failed to install Prometheus Node Exporter.${NC}"
    exit 1
fi

# Clean up
rm -rf node_exporter-${latest_version}.linux-amd64 $file_name

# Create a dedicated user for Prometheus Node Exporter
echo "${YELLOW}Creating dedicated user for Prometheus Node Exporter...${NC}"
sudo useradd -rs /bin/false node_exporter

if [ $? -ne 0 ]; then
    echo "${RED}Failed to create user for Prometheus Node Exporter.${NC}"
    exit 1
fi

# Create a systemd service file for Prometheus Node Exporter
echo "${YELLOW}Creating systemd service for Prometheus Node Exporter...${NC}"
sudo tee /etc/systemd/system/node_exporter.service > /dev/null <<EOL
[Unit]
Description=Prometheus Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=default.target
EOL

if [ $? -ne 0 ]; then
    echo "${RED}Failed to create systemd service file.${NC}"
    exit 1
fi

# Reload systemd and enable the service
echo "${YELLOW}Enabling and starting Prometheus Node Exporter service...${NC}"
sudo systemctl daemon-reload
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

if [ $? -ne 0 ]; then
    echo "${RED}Failed to enable or start Prometheus Node Exporter service.${NC}"
    exit 1
fi

echo "${GREEN}Prometheus Node Exporter installed and running successfully.${NC}"
