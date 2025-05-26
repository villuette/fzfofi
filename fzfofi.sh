#!/bin/bash

cache_dir="$HOME/.cache/app_launcher"
mkdir -p "$cache_dir"

cache_file="$cache_dir/cache"
hash_file="$cache_dir/hash"

mapfile -t desktop_dirs < <(printf "%s\n%s\n" "/usr/share/applications" "$HOME/.local/share/applications")
#flatpak support
desktop_dirs+=("$HOME/.local/share/flatpak/exports/share/applications")
desktop_dirs+=("/var/lib/flatpak/exports/share/applications")


# Compute hash of desktop file metadata
current_hash=$(for dir in "${desktop_dirs[@]}"; do
    if [ -d "$dir" ]; then
        find "$dir" -maxdepth 1 -type f -name "*.desktop" -printf "%p %T@\n" | sort
    fi
done | sha256sum | awk '{print $1}')

stored_hash=$(cat "$hash_file" 2>/dev/null || echo "")


#update hash due inequality
if [ "$current_hash" != "$stored_hash" ]; then
    printf "Updating cache...\n"

    # Find all desktop files in those dirs
    find "${desktop_dirs[@]}" -maxdepth 1 -type f -name "*.desktop" -exec sh -c '
    for file; do
        name=$(grep -m 1 "^Name=" "$file" | cut -d= -f2-)
        exec_line=$(grep -m 1 "^Exec=" "$file" | cut -d= -f2- | sed "s/%[uUfFdDnNp]//g")
        if [ -n "$name" ] && [ -n "$exec_line" ]; then
            echo "$name|$exec_line"
        fi
    done' _ {} + > "$cache_file"

    echo "$current_hash" > "$hash_file"
fi

#fzf in list 
selected=$(cut -d '|' -f1 "$cache_file" | sort | fzf --prompt=">> ")

if [ -n "$selected" ]; then
    #running selected application
    exec_line=$(grep "^$selected|" "$cache_file" | cut -d'|' -f2)
    swaymsg exec "$exec_line"
fi
