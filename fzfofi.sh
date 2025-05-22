#!/bin/sh

cache_dir="$HOME/.cache/app_launcher"
cache_file="$cache_dir/cache"
hash_file="$cache_dir/hash"

db_dir="/usr/share/applications"
db_cache="$db_dir/mimeinfo.cache"

mkdir -p "$cache_dir"

current_hash=$(sha256sum "$db_cache" 2>/dev/null | awk '{print $1}')

stored_hash=$(cat "$hash_file" 2>/dev/null || echo "")

#update hash due inequality
if [ "$current_hash" != "$stored_hash" ]; then
    printf "Updating cache...\n"

    #parsing Name|Exec
    find "$db_dir" -maxdepth 1 -type f -name "*.desktop" -exec sh -c '
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
