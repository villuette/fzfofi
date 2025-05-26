#!/bin/sh

set -e  # Exit on error

SCRIPT_NAME="fzfofi.sh"
CONFIG_NAME="fzfofi"
SWAY_CONFIG="$HOME/.config/sway/config"
WRAPPER_FILE="$HOME/.config/sway/$CONFIG_NAME"
INCLUDE_LINE="include ~/.config/sway/$CONFIG_NAME"


WRAPPER_CONTENTS="#### fzfofi (by install script) ####
# terminal appearance:
for_window [app_id=\"fzfofi\"] floating enable
for_window [app_id=\"fzfofi\"] resize set 800 200
for_window [app_id=\"fzfofi\"] move center
for_window [app_id=\"fzfofi\"] focus
set \$fzfofi kitty --app-id fzfofi -- bash -c '~/.config/sway/fzfofi.sh'
# (or any other term with --app-id; class may not work for Wayland)

# bind shortcut:
    bindsym \$mod+d exec \$fzfofi
"

# Ensure directories exist
mkdir -p "$HOME/.config/sway"

# Copy the main script
echo "Copying script into ~/.config/sway/ ..."
cp "./$SCRIPT_NAME" "$HOME/.config/sway/"
chmod +x "$HOME/.config/sway/$SCRIPT_NAME"
echo "Permissions updated."

# Write or overwrite wrapper config
echo "Writing wrapper config into ~/.config/sway/$CONFIG_NAME..."
printf "%s\n" "$WRAPPER_CONTENTS" > "$WRAPPER_FILE"

# Ensure only one correct include line exists
echo "Updating Sway config..."

# Remove existing include line for fzfofi only
sed -i "\|^$INCLUDE_LINE\$|d" "$SWAY_CONFIG"

# Append the new include line at the end
echo "$INCLUDE_LINE" >> "$SWAY_CONFIG"

echo "Installation complete."
echo "Now configured to use with kitty under sway."
echo "Read ~/.config/sway/fzfofi for usage instructions."