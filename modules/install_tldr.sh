#!/bin/bash

# Install tldr if not already installed
if ! command -v tldr &> /dev/null; then
    echo "${YELLOW}Installing tldr...${NC}"
    sudo apt install -y tldr
    tldr --update
    echo "${GREEN}tldr installed successfully.${NC}"
else
    echo "${GREEN}tldr is already installed. Skipping.${NC}"
fi
