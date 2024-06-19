#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/task/check-enable-ssh.sh)"

# Include colors
source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/lib/cli-colors.sh)



# Check if SSH service is enabled
if systemctl is-enabled ssh >/dev/null 2>&1; then
    echo "${GREEN}SSH service is already enabled.${NC}"
else
    echo "${RED}SSH service is not enabled. Enabling it...${NC}"
    sudo systemctl enable ssh
    if systemctl is-enabled ssh >/dev/null 2>&1; then
        echo "${GREEN}SSH service has been enabled.${NC}"
    else
        echo "${RED}Failed to enable SSH service.${NC}"
    fi
fi

# Check if SSH service is running
if systemctl is-active ssh >/dev/null 2>&1; then
    echo "${GREEN}SSH service is already running.${NC}"
else
    echo "${RED}SSH service is not running. Starting it...${NC}"
    sudo systemctl start ssh
    if systemctl is-active ssh >/dev/null 2>&1; then
        echo "${GREEN}SSH service has been started.${NC}"
    else
        echo "${RED}Failed to start SSH service.${NC}"
    fi
fi
