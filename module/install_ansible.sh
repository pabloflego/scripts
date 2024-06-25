#!/bin/bash

# Install Ansible
if ! command -v ansible &> /dev/null; then
    echo "${YELLOW}Installing Ansible...${NC}"
    sudo apt update
    sudo apt install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
    echo "${GREEN}Ansible installed successfully.${NC}"
else
    echo "${GREEN}Ansible is already installed. Skipping.${NC}"
fi
