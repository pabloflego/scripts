#!/bin/bash

# Install passlib for Python 3
if ! python3 -c "import passlib" &> /dev/null; then
    echo "${YELLOW}Installing passlib for Python 3...${NC}"
    sudo apt install -y python3-passlib
    echo "${GREEN}passlib for Python 3 installed successfully.${NC}"
else
    echo "${GREEN}passlib for Python 3 is already installed. Skipping.${NC}"
fi
