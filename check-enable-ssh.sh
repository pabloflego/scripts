#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/check-enable-ssh.sh)"

# Colors for echo messages
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
NC=$(tput sgr0) # No Color

# Check if SSH service is enabled
if systemctl is-enabled ssh >/dev/null 2>&1; then
    echo "${GREEN}SSH service is enabled.${NC}"
else
    echo "${RED}SSH service is not enabled. Enabling it...${NC}"
    sudo systemctl enable ssh
fi

# Check if SSH service is running
if systemctl is-active ssh >/dev/null 2>&1; then
    echo "${GREEN}SSH service is running.${NC}"
else
    echo "${RED}SSH service is not running. Starting it...${NC}"
    sudo systemctl start ssh
fi
