#!/bin/zsh
# Idempotently symlink all config files from configs/ to their respective locations

set -e

CONFIG_DIR="$(cd "$(dirname "$0")/.." && pwd)/configs"

# Map config subfolders to their target locations
# Add mappings as needed
# Format: subfolder target_path
CONFIG_MAP=(
    "git" "$HOME/.config/git"
    "powerlevel10k" "$HOME/.config/powerlevel10k"
    "vscode" "$HOME/Library/Application Support/Code/User"
)

for ((i=1; i<${#CONFIG_MAP[@]}; i+=2)); do
    SUBFOLDER=${CONFIG_MAP[i-1]}
    TARGET_DIR=${CONFIG_MAP[i]}
    SRC_DIR="$CONFIG_DIR/$SUBFOLDER"

    mkdir -p "$TARGET_DIR"

    for SRC_FILE in "$SRC_DIR"/*; do
        BASENAME=$(basename "$SRC_FILE")
        TARGET_FILE="$TARGET_DIR/$BASENAME"
        # Remove existing file/symlink if it exists and is not the correct symlink
        if [ -L "$TARGET_FILE" ]; then
            LINK_TARGET=$(readlink "$TARGET_FILE")
            if [ "$LINK_TARGET" != "$SRC_FILE" ]; then
                rm "$TARGET_FILE"
            fi
        elif [ -e "$TARGET_FILE" ]; then
            rm "$TARGET_FILE"
        fi
        # Create symlink if not present
        if [ ! -L "$TARGET_FILE" ]; then
            ln -s "$SRC_FILE" "$TARGET_FILE"
            echo "Symlinked $SRC_FILE -> $TARGET_FILE"
        else
            echo "Symlink already exists: $TARGET_FILE"
        fi
    done

done
