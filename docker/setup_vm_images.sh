#!/bin/bash

# Set URLs for the VM images
X86_URL="https://uofi.box.com/shared/static/1fcv8xpw708060og8x0ggbzmm2zesydl"
ARM_URL="https://uofi.box.com/shared/static/2cyoj7hwyw5ec8m5odt7gt37cbb3bsnd"

# Prebuilt URLs for the VM images
PREBUILT_X86_URL="https://uofi.box.com/shared/static/m8uid5hql7jjkvsyb1541oqt9xc8ysjw"
PREBUILT_ARM_URL="https://uofi.box.com/shared/static/zrayop1u7w59qskvkae92w3ekhpq44wr"

# Set output paths for the tar.gz files
X86_TAR="x86.img.tar.gz"
ARM_TAR="arm.img.tar.gz"

# Create directories for x86 and arm
mkdir -p x86 arm

# Colors
GREEN='\033[1;32m'
CYAN='\033[1;36m'
RESET='\033[0m'

# Function to download VM images
download_images() {
    echo -e "${CYAN}Downloading x86 image...${RESET}"
    curl -L $X86_URL --output $X86_TAR

    echo -e "${CYAN}Downloading ARM image...${RESET}"
    curl -L $ARM_URL --output $ARM_TAR

    echo -e "${CYAN}Extracting x86 image...${RESET}"
    tar -xzf $X86_TAR -C x86

    echo -e "${CYAN}Extracting ARM image...${RESET}"
    tar -xzf $ARM_TAR -C arm

    echo -e "${CYAN}Cleaning up tar.gz files...${RESET}"
    rm -f $X86_TAR $ARM_TAR
}

# Display usage instructions
usage() {
    echo -e "${GREEN}Usage:${RESET}"
    echo "  ./setup_vm_images.sh [options]"
    echo
    echo "Options:"
    echo "  -p    Download prebuilt VM images"
    echo "  -h    Show this help message"
    exit 0
}

# Parse command-line arguments
while getopts ":ph" opt; do
    case $opt in
        p)
            echo -e "${CYAN}Switching to prebuilt VM images...${RESET}"
            X86_URL=$PREBUILT_X86_URL
            ARM_URL=$PREBUILT_ARM_URL
            ;;
        h)
            usage
            ;;
        *)
            echo -e "${CYAN}Invalid option: -$OPTARG${RESET}"
            usage
            ;;
    esac
done

# Download and extract VM images
download_images

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
