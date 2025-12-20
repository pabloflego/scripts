#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/task/tmux-install-configure.sh)"
# bash -c "$(curl -fsSL https://github.com/pabloflego/scripts/raw/main/task/tmux-install-configure.sh)"

# Include colors
source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/lib/cli-colors.sh)

# Check if tmux is installed
echo "${YELLOW}Checking if tmux is installed...${NC}"
if command -v tmux &> /dev/null; then
    TMUX_VERSION=$(tmux -V)
    echo "${GREEN}tmux is already installed: $TMUX_VERSION. Task skipped.${NC}"
else
    echo "${YELLOW}tmux not found. Installing tmux...${NC}"
    
    # Detect package manager and install
    if command -v apt-get &> /dev/null; then
        sudo apt-get update -qq
        sudo apt-get install -y tmux
    elif command -v yum &> /dev/null; then
        sudo yum install -y tmux
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y tmux
    elif command -v brew &> /dev/null; then
        brew install tmux
    else
        echo "${RED}No supported package manager found. Please install tmux manually.${NC}"
        exit 1
    fi
    
    if [ $? -ne 0 ]; then
        echo "${RED}Failed to install tmux${NC}"
        exit 1
    fi
    
    echo "${GREEN}tmux installed successfully${NC}"
fi

# Download tmux configuration
TMUX_CONF="$HOME/.tmux.conf"
TMUX_CONF_URL="https://github.com/pabloflego/scripts/raw/main/dotfiles/.tmux.conf"
TEMP_CONF="/tmp/.tmux.conf"

echo "${YELLOW}Checking tmux configuration...${NC}"

# Check if config already exists and compare
if [[ -f "$TMUX_CONF" ]]; then
    echo "${YELLOW}Existing tmux config found, checking if update needed...${NC}"
    
    wget -q "$TMUX_CONF_URL" -O "$TEMP_CONF"
    
    if [[ $? -ne 0 ]]; then
        echo "${RED}Failed to download tmux configuration${NC}"
        exit 1
    fi
    
    if cmp -s "$TMUX_CONF" "$TEMP_CONF"; then
        echo "${GREEN}tmux configuration is already up to date. Task skipped.${NC}"
        rm -f "$TEMP_CONF"
    else
        echo "${YELLOW}Updating tmux configuration...${NC}"
        cp "$TMUX_CONF" "${TMUX_CONF}.backup"
        mv "$TEMP_CONF" "$TMUX_CONF"
        echo "${GREEN}tmux configuration updated (backup saved to ${TMUX_CONF}.backup)${NC}"
    fi
else
    echo "${YELLOW}Installing tmux configuration...${NC}"
    wget -q "$TMUX_CONF_URL" -O "$TMUX_CONF"
    
    if [[ $? -ne 0 ]]; then
        echo "${RED}Failed to download tmux configuration${NC}"
        exit 1
    fi
    
    echo "${GREEN}tmux configuration installed${NC}"
fi

# Install TPM (Tmux Plugin Manager)
TPM_DIR="$HOME/.tmux/plugins/tpm"

echo "${YELLOW}Checking TPM installation...${NC}"

if [[ -d "$TPM_DIR" ]]; then
    echo "${GREEN}TPM is already installed. Task skipped.${NC}"
else
    echo "${YELLOW}Installing TPM (Tmux Plugin Manager)...${NC}"
    
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    
    if [[ $? -ne 0 ]]; then
        echo "${RED}Failed to install TPM${NC}"
        exit 1
    fi
    
    echo "${GREEN}TPM installed successfully${NC}"
fi

# Install tmux plugins
echo "${YELLOW}Installing tmux plugins...${NC}"

# Check if tmux is running
if tmux info &> /dev/null; then
    echo "${YELLOW}tmux is running, reloading configuration...${NC}"
    tmux source-file "$TMUX_CONF"
fi

# Run TPM install script
"$TPM_DIR/bin/install_plugins"

if [[ $? -ne 0 ]]; then
    echo "${YELLOW}Failed to install plugins automatically. You can install them manually by:${NC}"
    echo "  1. Start tmux: ${YELLOW}tmux${NC}"
    echo "  2. Press: ${YELLOW}prefix + I${NC} (default prefix is backtick \`)"
else
    echo "${GREEN}tmux plugins installed successfully${NC}"
fi

echo ""
echo "${GREEN}Task completed successfully!${NC}"
echo ""
echo "${YELLOW}tmux configuration:${NC}"
echo "  Config file: ${GREEN}$TMUX_CONF${NC}"
echo "  TPM directory: ${GREEN}$TPM_DIR${NC}"
echo "  Prefix key: ${GREEN}\`${NC} (backtick)"
echo ""
echo "${YELLOW}Useful commands:${NC}"
echo "  Start tmux: ${GREEN}tmux${NC}"
echo "  Reload config: ${GREEN}prefix + r${NC}"
echo "  Install plugins: ${GREEN}prefix + I${NC}"
echo "  Update plugins: ${GREEN}prefix + U${NC}"
echo "  List sessions: ${GREEN}tmux ls${NC}"
