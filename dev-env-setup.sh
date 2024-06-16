#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/dev-env-setup.sh)"

# Colors for echo messages
GREEN=$(tput setaf 2)
# YELLOW=$(tput setaf 3)
# RED=$(tput setaf 1)
# NC=$(tput sgr0) # No Color

# # Prompt for email and name
# read -p "Enter your email for SSH key and Git configuration: " email
# read -p "Enter your name for Git configuration: " name

# # Update and upgrade the distro
# echo "${YELLOW}Updating and upgrading the distro...${NC}"
# sudo apt update && sudo apt upgrade -y

# # Generate an SSH key if it doesn't exist
# if [ ! -f ~/.ssh/id_ed25519 ]; then
#     echo "${YELLOW}Generating SSH key...${NC}"
#     ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N ""
#     eval "$(ssh-agent -s)"
#     ssh-add ~/.ssh/id_ed25519
# else
#     echo "${GREEN}SSH key already exists. Skipping generation.${NC}"
# fi

# # Configure Git identity globally if not already set
# current_email=$(git config --global user.email)
# current_name=$(git config --global user.name)

# if [ "$current_email" != "$email" ]; then
#     echo "${YELLOW}Configuring Git email...${NC}"
#     git config --global user.email "$email"
# else
#     echo "${GREEN}Git email is already set to $current_email. Skipping.${NC}"
# fi

# if [ "$current_name" != "$name" ]; then
#     echo "${YELLOW}Configuring Git name...${NC}"
#     git config --global user.name "$name"
# else
#     echo "${GREEN}Git name is already set to $current_name. Skipping.${NC}"
# fi

# # Install Zsh if not already installed
# if ! command -v zsh &> /dev/null; then
#     echo "${YELLOW}Installing Zsh...${NC}"
#     sudo apt install -y zsh
# else
#     echo "${GREEN}Zsh is already installed. Skipping.${NC}"
# fi

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "${YELLOW}Installing Oh My Zsh...${NC}"
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    chsh -s $(which zsh)
else
    echo "${GREEN}Oh My Zsh is already installed. Skipping.${NC}"
fi

# Install tldr if not already installed
if ! command -v tldr &> /dev/null; then
    echo "${YELLOW}Installing tldr...${NC}"
    sudo apt install -y tldr
    tldr --update
else
    echo "${GREEN}tldr is already installed. Skipping.${NC}"
fi

# Install Ansible
if ! command -v ansible &> /dev/null; then
    echo "${YELLOW}Installing Ansible...${NC}"
    sudo apt update
    sudo apt install -y software-properties-common
    sudo add-apt-repository --yes --update ppa:ansible/ansible
    sudo apt install -y ansible
else
    echo "${GREEN}Ansible is already installed. Skipping.${NC}"
fi

echo "${GREEN}Development environment setup complete!${NC}"
