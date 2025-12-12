#!/bin/bash

# Usage:
# bash -c "$(wget -qLO - https://github.com/pabloflego/scripts/raw/main/task/install-certificate.sh)"
# bash -c "$(curl -fsSL https://github.com/pabloflego/scripts/raw/main/task/install-certificate.sh)"

# Include colors
source <(wget -qO- https://github.com/pabloflego/scripts/raw/main/lib/cli-colors.sh)

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo "${RED}This script must be run as root${NC}"
   exit 1
fi

# Download CA certificate from repository
CA_CERT_URL="https://github.com/pabloflego/scripts/raw/main/ca/pablinCA.crt"
CA_CERT_DIR="/usr/local/share/ca-certificates"
CA_CERT_FILE="$CA_CERT_DIR/pablinCA.crt"

echo "${YELLOW}Downloading CA certificate...${NC}"
mkdir -p "$CA_CERT_DIR"
wget -q "$CA_CERT_URL" -O "$CA_CERT_FILE"

if [[ $? -ne 0 ]]; then
    echo "${RED}Failed to download CA certificate${NC}"
    exit 1
fi
echo "${GREEN}CA certificate downloaded${NC}"

# Check if certificate already exists
if [[ -f "$CA_CERT_FILE" ]]; then
    EXISTING_HASH=$(openssl x509 -noout -modulus -in "$CA_CERT_FILE" 2>/dev/null | openssl md5)
    DOWNLOADED_HASH=$(openssl x509 -noout -modulus -in "$CA_CERT_FILE" 2>/dev/null | openssl md5)
    
    if [[ "$EXISTING_HASH" == "$DOWNLOADED_HASH" ]]; then
        echo "${GREEN}CA certificate already installed and up to date. Task skipped.${NC}"
        exit 0
    fi
fi

# Update CA certificates
echo "${YELLOW}Updating CA certificates...${NC}"
sudo update-ca-certificates

if [[ $? -ne 0 ]]; then
    echo "${RED}Failed to update CA certificates${NC}"
    exit 1
fi
echo "${GREEN}CA certificates updated${NC}"

# Display certificate information
echo "${YELLOW}Verifying certificate installation...${NC}"
EXPIRY_DATE=$(openssl x509 -enddate -noout -in "$CA_CERT_FILE" | cut -d= -f2)
SUBJECT=$(openssl x509 -subject -noout -in "$CA_CERT_FILE" | sed 's/subject=//')
ISSUER=$(openssl x509 -issuer -noout -in "$CA_CERT_FILE" | sed 's/issuer=//')

echo ""
echo "${GREEN}Certificate Details:${NC}"
echo "  Subject: ${YELLOW}$SUBJECT${NC}"
echo "  Issuer: ${YELLOW}$ISSUER${NC}"
echo "  Expires: ${YELLOW}$EXPIRY_DATE${NC}"
echo "  CA Certificate: ${YELLOW}$CA_CERT_FILE${NC}"

echo ""
echo "${GREEN}Task completed successfully. CA certificate installed.${NC}"
