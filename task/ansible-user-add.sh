#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/task/ansible-user-add.sh)"

# Colors for echo messages
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RED=$(tput setaf 1)
NC=$(tput sgr0) # No Color

# Check if the ansible user already exists
if id "ansible" &>/dev/null; then
    echo "${GREEN}User 'ansible' already exists. Skipping user creation and SSH key configuration.${NC}"
else
    # Prompt for the password
    read -sp 'Enter password for ansible user: ' PASSWORD
    echo

    # Prompt for the SSH public key
    read -p 'Enter SSH public key for ansible user: ' SSH_KEY

    # Add ansible user
    echo "${YELLOW}Creating ansible user...${NC}"
    if useradd -m -s /bin/bash ansible; then
        echo "${GREEN}User 'ansible' created successfully.${NC}"

        # Set the password for ansible user
        echo "ansible:$PASSWORD" | chpasswd
        echo "${GREEN}Password set for ansible user.${NC}"

        # Add ansible user to sudoers
        if usermod -aG sudo ansible; then
            echo "${GREEN}User 'ansible' added to sudo group.${NC}"
        else
            echo "${RED}Failed to add user 'ansible' to sudo group.${NC}"
        fi

        # Configure SSH key-based authentication
        SSH_DIR="/home/ansible/.ssh"
        AUTH_KEYS="$SSH_DIR/authorized_keys"

        echo "${YELLOW}Setting up SSH directory...${NC}"
        mkdir -p "$SSH_DIR"
        chown ansible:ansible "$SSH_DIR"
        chmod 700 "$SSH_DIR"

        echo "${YELLOW}Adding SSH key to authorized_keys...${NC}"
        echo "$SSH_KEY" >> "$AUTH_KEYS"
        chown ansible:ansible "$AUTH_KEYS"
        chmod 600 "$AUTH_KEYS"
        echo "${GREEN}SSH key added successfully.${NC}"

    else
        echo "${RED}Failed to create user 'ansible'.${NC}"
    fi
fi

# Add ansible user to sudoers with NOPASSWD if not already set
SUDOERS_FILE="/etc/sudoers.d/ansible"
SUDOERS_ENTRY="ansible ALL=(ALL) NOPASSWD:ALL"

if [ -f "$SUDOERS_FILE" ] && grep -q "$SUDOERS_ENTRY" "$SUDOERS_FILE"; then
    echo "${GREEN}ansible user already has NOPASSWD sudoers entry. Skipping.${NC}"
else
    echo "${YELLOW}Adding ansible user to sudoers with NOPASSWD...${NC}"
    echo "$SUDOERS_ENTRY" > "$SUDOERS_FILE"
    chmod 440 "$SUDOERS_FILE"
    echo "${GREEN}ansible user added to sudoers with NOPASSWD.${NC}"
fi

# Call the check-enable-ssh.sh script
bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/check-enable-ssh.sh)"

echo "${GREEN}Ansible user setup completed successfully.${NC}"
