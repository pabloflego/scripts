#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/dev-env-setup.sh)"

# Prompt for email and name
read -p "Enter your email for SSH key and Git configuration: " email
read -p "Enter your name for Git configuration: " name

# Update and upgrade the distro
echo "Updating and upgrading the distro..."
sudo apt update && sudo apt upgrade -y

# Generate an SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_ed25519 ]; then
    echo "Generating SSH key..."
    ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N ""
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
else
    echo "SSH key already exists. Skipping generation."
fi

# Configure Git identity globally if not already set
current_email=$(git config --global user.email)
current_name=$(git config --global user.name)

if [ "$current_email" != "$email" ]; then
    echo "Configuring Git email..."
    git config --global user.email "$email"
else
    echo "Git email is already set to $current_email. Skipping."
fi

if [ "$current_name" != "$name" ]; then
    echo "Configuring Git name..."
    git config --global user.name "$name"
else
    echo "Git name is already set to $current_name. Skipping."
fi

# Install Zsh if not already installed
if ! command -v zsh &> /dev/null; then
    echo "Installing Zsh..."
    sudo apt install -y zsh
else
    echo "Zsh is already installed. Skipping."
fi

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed. Skipping."
fi

# Install tldr if not already installed
if ! command -v tldr &> /dev/null; then
    echo "Installing tldr..."
    sudo apt install -y tldr
    tldr --update
else
    echo "tldr is already installed. Skipping."
fi

echo "Development environment setup complete!"
