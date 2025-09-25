#!/bin/zsh
# main.sh - Execute all scripts in the scripts/ folder in order

SCRIPT_DIR="$(dirname "$0")/scripts"

for script in "$SCRIPT_DIR"/*.sh; do
    echo "Running $script..."
    zsh "$script"
    if [[ $? -ne 0 ]]; then
        echo "Error executing $script. Exiting."
        exit 1
    fi
done

echo "All scripts executed successfully."
