#!/bin/bash

# Prompt for the password
read -sp 'Enter password for ansible user: ' PASSWORD
echo

# Prompt for the SSH public key
read -p 'Enter SSH public key for ansible user: ' SSH_KEY

# Add ansible user
useradd -m -s /bin/bash ansible

# Set the password for ansible user
echo "ansible:$PASSWORD" | chpasswd

# Add ansible user to sudoers
usermod -aG sudo ansible

# Configure SSH key-based authentication
mkdir -p /home/ansible/.ssh
echo "$SSH_KEY" > /home/ansible/.ssh/authorized_keys
chown -R ansible:ansible /home/ansible/.ssh
chmod 700 /home/ansible/.ssh
chmod 600 /home/ansible/.ssh/authorized_keys

echo "Ansible user setup completed successfully."
