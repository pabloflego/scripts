#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/task/dev-env-setup.sh)"

# Include colors
source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/lib/cli-colors.sh)

echo "${YELLOW}Development Environment Setup${NC}"

# Function to show checkbox options
show_checkboxes() {
    options=(
        "Configure Git"
        "Install Zsh"
        "Install Oh My Zsh"
        "Install tldr"
        "Install Ansible"
        "Install passlib for Python 3"
        "Install Node Version Manager (NVM)"
    )

    selections=()

    for opt in "${options[@]}"; do
        selections+=("false")
    done

    for i in "${!options[@]}"; do
        read -p "${options[$i]}? [y/n]: " choice
        if [[ "$choice" =~ ^[yY]$ ]]; then
            selections[$i]="true"
        fi
    done

    echo "${selections[@]}"
}

# Get user selections
selections=($(show_checkboxes))

# Update and upgrade the distro
echo "${YELLOW}Updating and upgrading the distro...${NC}"
sudo apt update && sudo apt upgrade -y

# Base URL for modules
BASE_URL="https://github.com/pabloflego/scripts/raw/main/modules"

# List of modules
modules=(
    "configure_git.sh"
    "install_zsh.sh"
    "install_oh_my_zsh.sh"
    "install_tldr.sh"
    "install_ansible.sh"
    "install_passlib.sh"
    "install_nvm.sh"
)

# Execute based on selections
for i in "${!selections[@]}"; do
    if [ "${selections[$i]}" == "true" ]; then
        source <(wget -qO- "${BASE_URL}/${modules[$i]}")
    fi
done

echo "${GREEN}Development environment setup complete!${NC}"
