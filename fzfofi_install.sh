echo "Copying script into ~/.config/sway/ ..."
cp ./fzfofi.sh ~/.config/sway/
echo "Changing permissions..."
chmod +x ~/.config/sway/fzfofi.sh
echo "Writing sway wrapper in ~/.config/sway/fzfofi..."
echo "#### fzfofi (by install script) ####
# terminal appearance:
for_window [app_id="fzfofi"] floating enable
for_window [app_id="fzfofi"] resize set 800 200
for_window [app_id="fzfofi"] move center
for_window [app_id="fzfofi"] focus
set \$fzfofi kitty --app-id fzfofi -- sh -c '~/.config/sway/fzfofi.sh' 
# (or any other term with --app-id (class not worked for wayland))

# bind shortcut:
#    bindsym \$mod+d exec \$fzfofi
" >> ~/.config/sway/fzfofi
echo "Including in sway config file..."
echo "include ~/.config/sway/fzfofi" >> ~/.config/sway/config
echo "Installation complete. \nNow its configured and tested only to use with kitty under sway. \nRead ~/.config/sway/fzfofi for usage."
