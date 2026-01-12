#!/bin/bash
set -euo pipefail

#   sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/awkirin/awk-snippets/refs/heads/main/scripts/awk-update.sh)"

#!/bin/bash

# Функция для создания папок
create_folders() {
    local base_dir=$1
    local json_data=$2
    
    echo "$json_data" | jq -r 'keys[]' | while read key; do
        new_dir="$base_dir/$key"
        mkdir -p "$new_dir"
        echo "Created: $new_dir"
        
        # Получаем содержимое подпапок
        subfolders=$(echo "$json_data" | jq -r ".$key[]")
        if [ "$subfolders" != "null" ] && [ -n "$subfolders" ]; then
            echo "$subfolders" | while read subfolder; do
                mkdir -p "$new_dir/$subfolder"
                echo "Created: $new_dir/$subfolder"
            done
        fi
    done
}

json_data=$(cat structure.json)
create_folders "." "$json_data"
