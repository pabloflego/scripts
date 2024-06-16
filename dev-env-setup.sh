#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/dev-env-setup.sh)"

# Update and upgrade the distro
echo "Updating and upgrading the distro..."
sudo apt update && sudo apt upgrade -y

# Generate an SSH key
echo "Generating SSH key..."
ssh-keygen -t ed25519 -C "pablinff@gmail.com" -f ~/.ssh/id_ed25519 -N ""
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519

# Install Zsh and Oh My Zsh
echo "Installing Zsh..."
sudo apt install -y zsh
echo "Installing Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install tldr
echo "Installing tldr..."
sudo apt install -y tldr
tldr --update

echo "Development environment setup complete!"
