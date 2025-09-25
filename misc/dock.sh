#!/usr/bin/env bash

source "./dock_functions.sh"

declare -a apps=(
    '/Applications/Firefox.app'
    '/Applications/Visual Studio Code.app'
    '/System/Applications/Messages.app'
    '/Applications/Obsidian.app'
    '/System/Applications/Photos.app'
    '/Applications/Qobuz.app'
    '/Applications/Native Instruments/Traktor Pro 3/Traktor.app'
);

declare -a folders=(
    ~/Downloads
);

clear_dock
disable_recent_apps_from_dock

for app in "${apps[@]}"; do
    add_app_to_dock "$app"
done

for folder in "${folders[@]}"; do
    add_folder_to_dock $folder
done

killall Dock
