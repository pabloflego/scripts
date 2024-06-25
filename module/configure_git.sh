#!/bin/bash

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
