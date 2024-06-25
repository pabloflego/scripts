#!/bin/bash

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
