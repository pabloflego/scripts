#!/bin/bash

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
