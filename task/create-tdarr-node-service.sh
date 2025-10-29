#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/task/create-tdarr-node-service.sh)"

# Include colors
source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/lib/cli-colors.sh)

# Define binary path
BINARY_PATH="/home/users/pablo/tdarr/Tdarr_Node/Tdarr_Node"
SERVICE_NAME="tdarr-node"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
WORKING_DIR="/home/users/pablo/tdarr/Tdarr_Node"

# Check if binary exists
echo "${YELLOW}Checking if Tdarr_Node binary exists...${NC}"
if [ ! -f "$BINARY_PATH" ]; then
    echo "${RED}Tdarr_Node binary not found at $BINARY_PATH${NC}"
    echo "${RED}Please ensure the binary is installed at the correct location.${NC}"
    exit 1
fi

echo "${GREEN}Tdarr_Node binary found at $BINARY_PATH${NC}"

# Check if service already exists
if systemctl list-unit-files | grep -q "$SERVICE_NAME.service"; then
    echo "${YELLOW}Service $SERVICE_NAME already exists. Checking if it's running...${NC}"
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo "${GREEN}Service $SERVICE_NAME is already running. Task skipped.${NC}"
        exit 0
    else
        echo "${YELLOW}Service exists but not running. Will restart it.${NC}"
    fi
else
    echo "${YELLOW}Creating systemd service for Tdarr Node...${NC}"
fi

# Make binary executable
echo "${YELLOW}Ensuring binary is executable...${NC}"
sudo chmod +x "$BINARY_PATH"

if [ $? -ne 0 ]; then
    echo "${RED}Failed to make binary executable.${NC}"
    exit 1
fi

# Create systemd service file
echo "${YELLOW}Creating systemd service file...${NC}"
sudo tee "$SERVICE_FILE" > /dev/null <<EOF
[Unit]
Description=Tdarr Node Daemon
After=network.target

[Service]
User=root
Group=root
Type=simple
WorkingDirectory=$WORKING_DIR
ExecStart=$BINARY_PATH
TimeoutStopSec=20
KillMode=process
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

if [ $? -ne 0 ]; then
    echo "${RED}Failed to create systemd service file.${NC}"
    exit 1
fi

echo "${GREEN}Systemd service file created successfully.${NC}"

# Reload systemd daemon
echo "${YELLOW}Reloading systemd daemon...${NC}"
sudo systemctl daemon-reload

if [ $? -ne 0 ]; then
    echo "${RED}Failed to reload systemd daemon.${NC}"
    exit 1
fi

# Enable the service
echo "${YELLOW}Enabling $SERVICE_NAME service...${NC}"
sudo systemctl enable "$SERVICE_NAME"

if [ $? -ne 0 ]; then
    echo "${RED}Failed to enable $SERVICE_NAME service.${NC}"
    exit 1
fi

# Start the service
echo "${YELLOW}Starting $SERVICE_NAME service...${NC}"
sudo systemctl start "$SERVICE_NAME"

if [ $? -ne 0 ]; then
    echo "${RED}Failed to start $SERVICE_NAME service.${NC}"
    exit 1
fi

# Check service status
echo "${YELLOW}Checking service status...${NC}"
if systemctl is-active --quiet "$SERVICE_NAME"; then
    echo "${GREEN}Tdarr Node service created and started successfully!${NC}"
    echo "${GREEN}Service status:${NC}"
    sudo systemctl status "$SERVICE_NAME" --no-pager -l
else
    echo "${RED}Service was created but failed to start properly.${NC}"
    echo "${RED}Service status:${NC}"
    sudo systemctl status "$SERVICE_NAME" --no-pager -l
    exit 1
fi

echo "${GREEN}Task completed successfully. Tdarr Node is now running as a systemd service.${NC}"
echo "${YELLOW}You can manage the service using:${NC}"
echo "  sudo systemctl start $SERVICE_NAME"
echo "  sudo systemctl stop $SERVICE_NAME"
echo "  sudo systemctl restart $SERVICE_NAME"
echo "  sudo systemctl status $SERVICE_NAME"