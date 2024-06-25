#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/tasks/dev-env-setup.sh)"

# Include colors
source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/lib/cli-colors.sh)

echo "${YELLOW}Development Environment Setup${NC}"

# Function to ask user for choice
ask_choice() {
    while true; do
        read -p "$1 [y/n]: " choice
        case "$choice" in
            y|Y ) return 0;;
            n|N ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

# Update and upgrade the distro
echo "${YELLOW}Updating and upgrading the distro...${NC}"
sudo apt update && sudo apt upgrade -y

# Prompt for each module
if ask_choice "Do you want to configure Git?"; then
    source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/modules/configure_git.sh)
fi

if ask_choice "Do you want to install Zsh?"; then
    source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/modules/install_zsh.sh)
fi

if ask_choice "Do you want to install Oh My Zsh?"; then
    source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/modules/install_oh_my_zsh.sh)
fi

if ask_choice "Do you want to install tldr?"; then
    source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/modules/install_tldr.sh)
fi

if ask_choice "Do you want to install Ansible?"; then
    source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/modules/install_ansible.sh)
fi

if ask_choice "Do you want to install passlib for Python 3?"; then
    source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/modules/install_passlib.sh)
fi

if ask_choice "Do you want to install Node Version Manager (NVM)?"; then
    source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/modules/install_nvm.sh)
fi

echo "${GREEN}Development environment setup complete!${NC}"
