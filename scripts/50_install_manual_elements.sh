#!/bin/bash
set -euo pipefail

# something weird happening that breaks the script after running it; thus putting it separately from other installation settings.
read -r -p "Do you want to import the BetterTouchTool preset? (y/n): " choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    if [ -e /Applications/BetterTouchTool.app/Contents/MacOS/BetterTouchTool ]; then
        /Applications/BetterTouchTool.app/Contents/MacOS/BetterTouchTool import_preset Default.bttpreset
        echo "✓ Preset imported"
    else
        echo "⚠️  BetterTouchTool not found — skipping preset import."
    fi
else
    echo "Skipped BetterTouchTool preset import."
fi

# ---------- Traktor Pro 3 ----------
if [ -e '/Applications/Native Instruments/Traktor Pro 3/Traktor.app' ]; then
    echo "✓ Traktor Pro 3 already installed"
else
    echo "Traktor Pro needs to be installed via Native Access (not available via Brew)."
    read -s -p "Press Enter to open Native Access website and install manually"
    open "https://www.native-instruments.com/en/specials/native-access/"
fi
