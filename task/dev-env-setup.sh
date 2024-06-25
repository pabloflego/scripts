#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/task/dev-env-setup.sh)"

# Include colors
source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/lib/cli-colors.sh)

echo "${YELLOW}Development Environment Setup${NC}"

# Ensure whiptail is installed
if ! command -v whiptail &> /dev/null; then
    echo "${YELLOW}Installing whiptail...${NC}"
    sudo apt-get install -y whiptail
fi

# Function to show checkbox options using whiptail
show_checkboxes() {
    whiptail --title "Development Environment Setup" --checklist \
    "Choose options to install:" 20 78 10 \
    "Configure_Git" "" ON \
    "Install_Zsh" "" ON \
    "Install_Oh_My_Zsh" "" ON \
    "Install_tldr" "" ON \
    "Install_Ansible" "" ON \
    "Install_passlib_for_Python_3" "" ON \
    "Install_Node_Version_Manager_(NVM)" "" ON 3>&1 1>&2 2>&3
}

# Get user selections
selections=$(show_checkboxes)

# Print selections for debugging
echo "Selections: $selections"

# Update and upgrade the distro
echo "${YELLOW}Updating and upgrading the distro...${NC}"
sudo apt update && sudo apt upgrade -y

# Base URL for modules
BASE_URL="https://github.com/pabloflego/scripts/raw/main/module"

# List of modules
declare -A modules
modules=(
    ["Configure_Git"]="configure_git.sh"
    ["Install_Zsh"]="install_zsh.sh"
    ["Install_Oh_My_Zsh"]="install_oh_my_zsh.sh"
    ["Install_tldr"]="install_tldr.sh"
    ["Install_Ansible"]="install_ansible.sh"
    ["Install_passlib_for_Python_3"]="install_passlib.sh"
    ["Install_Node_Version_Manager_(NVM)"]="install_nvm.sh"
)

# Execute based on selections
for selection in $selections; do
    module=$(echo $selection | tr -d '"')
    source <(wget -qO- "${BASE_URL}/${modules[$module]}")
done

echo "${GREEN}Development environment setup complete!${NC}"
