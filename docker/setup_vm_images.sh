#!/bin/bash

# Set URLs for the VM images
X86_URL="https://uofi.box.com/shared/static/1fcv8xpw708060og8x0ggbzmm2zesydl"
ARM_URL="https://uofi.box.com/shared/static/2cyoj7hwyw5ec8m5odt7gt37cbb3bsnd"

# Set output paths for the tar.gz files
X86_TAR="x86.img.tar.gz"
ARM_TAR="arm.img.tar.gz"

# Create directories for x86 and arm
mkdir -p x86 arm

# Colors
GREEN='\033[1;32m'
CYAN='\033[1;36m'
RESET='\033[0m'

# Download the x86 image
echo -e "${CYAN}Downloading x86 image...${RESET}"
curl -L $X86_URL --output $X86_TAR

# Download the arm image
echo -e "${CYAN}Downloading arm image...${RESET}"
curl -L $ARM_URL --output $ARM_TAR

# Extract the x86 image
echo -e "${CYAN}Extracting x86 image...${RESET}"
tar -xzf $X86_TAR -C x86

# Extract the arm image
echo -e "${CYAN}Extracting arm image...${RESET}"
tar -xzf $ARM_TAR -C arm

# Clean up tar.gz files
echo -e "${CYAN}Cleaning up downloaded tar.gz files...${RESET}"
rm -f $X86_TAR $ARM_TAR

# Verify the extraction
echo -e "${GREEN}Contents of x86 directory:${RESET}"
for file in x86/*; do
  echo -e "  ${CYAN}$(basename "$file")${RESET}"
done

echo -e "${GREEN}Contents of arm directory:${RESET}"
for file in arm/*; do
  echo -e "  ${CYAN}$(basename "$file")${RESET}"
done

echo -e "${CYAN}Setup complete. Images are stored in 'x86' and 'arm' directories.${RESET}"
