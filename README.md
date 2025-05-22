# fzfofi
## Description
Simple tui program like `rofi` and others, for simple starting desktop applications in sway.
## Dependencies
*important: installer writes include in ~/.config/sway/config file and creates a directory near it*
- `fzf`
- `sway`
## Installation
Just run:
```git clone https://github.com/villuette/fzfofi.git /tmp/fzfofi
cd /tmp/fzfofi
chmod +x ./fzfofi_install.sh
./fzfofi_install.sh
```
then open file `~/.config/sway/fzfofi` and uncomment bindsym (*change this shortcut if exists*)
after that, reload sway (by default `Mod+Shift+C`)

## Notes
made for fun, never written shell scripts before, open to discuss :)
