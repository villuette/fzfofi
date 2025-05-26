#!/bin/bash

# Define where desktop files are stored
DESKTOP_DIR="$HOME/.local/share/applications"

# Ask user for inputs
read -p "Enter application name: " APP_NAME
read -p "Enter full path to the binary: " BINARY_PATH

# Convert app name to lowercase and replace spaces with hyphens for filename
FILENAME="${APP_NAME,,}"            # convert to lowercase
FILENAME="${FILENAME// /-}.desktop" # replace spaces with hyphens and add .desktop

# Ensure the applications directory exists
mkdir -p "$DESKTOP_DIR"

# Full path to the new desktop file
DESKTOP_FILE="$DESKTOP_DIR/$FILENAME"

# Write the desktop file content
cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=$APP_NAME
Exec=$BINARY_PATH
Type=Application
Terminal=false
Icon=
Categories=Utility;
EOL

echo "Desktop file created at: $DESKTOP_FILE"