#!/bin/bash

set -euox pipefail

#!/bin/bash

############################## MS FONTS ######################################
# Define variables
REPO_URL="https://github.com/tazihad/win10-fonts/archive/refs/heads/main.zip"
DEST_DIR="/usr/share/fonts/msfonts"
ZIP_FILE="/tmp/win10-fonts.zip"

# Ensure curl and unzip are available
if ! command -v curl &> /dev/null || ! command -v unzip &> /dev/null; then
    echo "Error: This script requires 'curl' and 'unzip'. Please install them and try again."
    exit 1
fi

# Create destination directory with root privileges
echo "Creating destination directory at $DEST_DIR..."
sudo mkdir -p "$DEST_DIR"

# Download the repository as a zip file
echo "Downloading win10-fonts repository (size: ~187MB)..."
curl -L "$REPO_URL" -o "$ZIP_FILE"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download fonts archive."
    exit 1
fi

# Extract the zip file
echo "Extracting fonts..."
unzip -q "$ZIP_FILE" -d "/tmp"
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract fonts archive."
    rm -f "$ZIP_FILE"
    exit 1
fi

# Move fonts to the destination directory with root privileges
echo "Moving fonts to $DEST_DIR..."
sudo mv /tmp/win10-fonts-main/* "$DEST_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to move fonts to $DEST_DIR."
    rm -f "$ZIP_FILE"
    rm -rf "/tmp/win10-fonts-main"
    exit 1
fi

# Cleanup downloaded and temporary files
echo "Cleaning up temporary files..."
rm -f "$ZIP_FILE"
rm -rf "/tmp/win10-fonts-main"

# Refresh font cache
echo "Refreshing font cache..."
sudo fc-cache -fv > /dev/null 2>&1
if [ $? -ne 0 ]; then
    echo "Error: Failed to refresh font cache."
    exit 1
fi

echo "Fonts installed successfully in $DEST_DIR for all users."

##########################################################################