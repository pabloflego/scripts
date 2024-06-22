#!/bin/bash

# Usage:
# sudo bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/task/rename-user.sh)" oldusername newusername

# Include colors
source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/lib/cli-colors.sh)

if [ "$#" -ne 2 ]; then
    echo "${RED}Usage: sudo bash -c \"\$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/task/rename-user.sh)\" oldusername newusername${NC}"
    exit 1
fi

oldusername=$1
newusername=$2

# Check for active sessions
if who | grep -q "^$oldusername"; then
    echo "${RED}User $oldusername is currently logged in. Please log out the user before renaming.${NC}"
    exit 1
fi

# Rename the user
echo "${YELLOW}Renaming user $oldusername to $newusername...${NC}"
sudo usermod -l "$newusername" "$oldusername"

# Rename the user's home directory
if [ -d "/home/$oldusername" ]; then
    echo "${YELLOW}Renaming home directory /home/$oldusername to /home/$newusername...${NC}"
    sudo usermod -m -d "/home/$newusername" "$newusername"
fi

# Update the group name (if needed)
if getent group "$oldusername" >/dev/null; then
    echo "${YELLOW}Renaming group $oldusername to $newusername...${NC}"
    sudo groupmod -n "$newusername" "$oldusername"
fi

echo "${GREEN}User $oldusername has been renamed to $newusername successfully.${NC}"
