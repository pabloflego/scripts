#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/task/dev-env-setup.sh)"

# Include colors
source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/lib/cli-colors.sh)

# Update and upgrade the distro
echo "${YELLOW}Updating and upgrading the distro...${NC}"
sudo apt update && sudo apt upgrade -y

# Generate an SSH key if it doesn't exist
if [ ! -f ~/.ssh/id_ed25519 ]; then
    read -p "Enter your email for SSH key: " email
    echo "${YELLOW}Generating SSH key...${NC}"
    ssh-keygen -t ed25519 -C "$email" -f ~/.ssh/id_ed25519 -N ""
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    echo "${GREEN}SSH key generated successfully.${NC}"
else
    echo "${GREEN}SSH key already exists. Skipping generation.${NC}"
fi

# Configure Git identity globally if not already set
current_email=$(git config --global user.email)
current_name=$(git config --global user.name)

if [ -z "$current_email" ]; then
    read -p "Enter your email for Git configuration: " email
    echo "${YELLOW}Configuring Git email...${NC}"
    git config --global user.email "$email"
    echo "${GREEN}Git email configured successfully.${NC}"
else
    echo "${GREEN}Git email is already set to $current_email. Skipping.${NC}"
fi

if [ -z "$current_name" ]; then
    read -p "Enter your name for Git configuration: " name
    echo "${YELLOW}Configuring Git name...${NC}"
    git config --global user.name "$name"
    echo "${GREEN}Git name configured successfully.${NC}"
else
    echo "${GREEN}Git name is already set to $current_name. Skipping.${NC}"
fi

# Install Zsh if not already installed
if ! command -v zsh &> /dev/null; then
    echo "${YELLOW}Installing Zsh...${NC}"
    sudo apt install -y zsh
    echo "${GREEN}Zsh installed successfully.${NC}"
else
    echo "${GREEN}Zsh is already installed. Skipping.${NC}"
fi

# Install Oh My Zsh if not already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "${YELLOW}Installing Oh My Zsh...${NC}"
    RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    chsh -s $(which zsh)
    echo "${GREEN}Oh My Zsh installed successfully.${NC}"
else
    echo "${GREEN}Oh My Zsh is already installed. Skipping.${NC}"
fi

# Install Zsh plugins if not already installed
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "${YELLOW}Installing zsh-autosuggestions...${NC}"
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
    echo "${GREEN}zsh-autosuggestions installed successfully.${NC}"
else
    echo "${GREEN}zsh-autosuggestions is already installed. Skipping.${NC}"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "${YELLOW}Installing zsh-syntax-highlighting...${NC}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    echo "${GREEN}zsh-syntax-highlighting installed successfully.${NC}"
else
    echo "${GREEN}zsh-syntax-highlighting is already installed. Skipping.${NC}"
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
    echo "${YELLOW}Installing zsh-completions...${NC}"
    git clone https://github.com/zsh-users/zsh-completions $ZSH_CUSTOM/plugins/zsh-completions
    echo "${GREEN}zsh-completions installed successfully.${NC}"
else
    echo "${GREEN}zsh-completions is already installed. Skipping.${NC}"
fi

# Enable the plugins in .zshrc if not already enabled
if ! grep -q "zsh-autosuggestions" ~/.zshrc; then
    echo "${YELLOW}Enabling zsh-autosuggestions in .zshrc...${NC}"
    sed -i 's/plugins=(/plugins=(zsh-autosuggestions /' ~/.zshrc
    echo "${GREEN}zsh-autosuggestions enabled in .zshrc.${NC}"
else
    echo "${GREEN}zsh-autosuggestions is already enabled in .zshrc. Skipping.${NC}"
fi

if ! grep -q "zsh-syntax-highlighting" ~/.zshrc; then
    echo "${YELLOW}Enabling zsh-syntax-highlighting in .zshrc...${NC}"
    sed -i 's/plugins=(/plugins=(zsh-syntax-highlighting /' ~/.zshrc
    echo "${GREEN}zsh-syntax-highlighting enabled in .zshrc.${NC}"
else
    echo "${GREEN}zsh-syntax-highlighting is already enabled in .zshrc. Skipping.${NC}"
fi

if ! grep -q "zsh-completions" ~/.zshrc; then
    echo "${YELLOW}Enabling zsh-completions in .zshrc...${NC}"
    sed -i 's/plugins=(/plugins=(zsh-completions /' ~/.zshrc
    echo "${GREEN}zsh-completions enabled in .zshrc.${NC}"
else
    echo "${GREEN}zsh-completions is already enabled in .zshrc. Skipping.${NC}"
fi

# Install tldr if not already installed
if ! command -v tldr &> /dev/null; then
    echo "${YELLOW}Installing tldr...${NC}"
    sudo apt install -y tldr
    tldr --update
    echo "${GREEN}tldr installed successfully.${NC}"
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
    echo "${GREEN}Ansible installed successfully.${NC}"
else
    echo "${GREEN}Ansible is already installed. Skipping.${NC}"
fi

# Install passlib for Python 3
if ! python3 -c "import passlib" &> /dev/null; then
    echo "${YELLOW}Installing passlib for Python 3...${NC}"
    sudo apt install -y python3-passlib
    echo "${GREEN}passlib for Python 3 installed successfully.${NC}"
else
    echo "${GREEN}passlib for Python 3 is already installed. Skipping.${NC}"
fi

# Install Node Version Manager (NVM) if not already installed
if [ ! -d "$HOME/.nvm" ]; then
    echo "${YELLOW}Installing Node Version Manager (NVM)...${NC}"
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
    echo "${GREEN}NVM installed successfully.${NC}"
else
    echo "${GREEN}NVM is already installed. Skipping.${NC}"
fi

# Install the latest LTS version of Node.js using NVM
if command -v nvm &> /dev/null; then
    echo "${YELLOW}Installing the latest LTS version of Node.js using NVM...${NC}"
    nvm install --lts
    nvm use --lts
    nvm alias default 'lts/*'
    echo "${GREEN}Node.js and npm installed successfully using NVM.${NC}"
else
    echo "${RED}NVM is not installed. Skipping Node.js installation.${NC}"
fi

echo "${GREEN}Development environment setup complete!${NC}"
