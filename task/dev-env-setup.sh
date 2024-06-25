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

# Execute based on selections
modules=(
    "https://github.com/pabloflego/scripts/raw/main/modules/configure_git.sh"
    "https://github.com/pabloflego/scripts/raw/main/modules/install_zsh.sh"
    "https://github.com/pabloflego/scripts/raw/main/modules/install_oh_my_zsh.sh"
    "https://github.com/pabloflego/scripts/raw/main/modules/install_tldr.sh"
    "https://github.com/pabloflego/scripts/raw/main/modules/install_ansible.sh"
    "https://github.com/pabloflego/scripts/raw/main/modules/install_passlib.sh"
    "https://github.com/pabloflego/scripts/raw/main/modules/install_nvm.sh"
)

for i in "${!selections[@]}"; do
    if [ "${selections[$i]}" == "true" ]; then
        source <(wget -qO- "${modules[$i]}")
    fi
done

echo "${GREEN}Development environment setup complete!${NC}"
