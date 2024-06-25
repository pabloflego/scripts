#!/bin/bash

# Install Zsh if not already installed
if ! command -v zsh &> /dev/null; then
    echo "${YELLOW}Installing Zsh...${NC}"
    sudo apt install -y zsh
    echo "${GREEN}Zsh installed successfully.${NC}"
else
    echo "${GREEN}Zsh is already installed. Skipping.${NC}"
fi
