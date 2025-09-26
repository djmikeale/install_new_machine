#! /bin/bash

echo "install dbt in venv - found dbt guide online"
echo "Need to download the real thing: https://www.python.org/downloads/release/python-3810/ (3.8 or maybe 3.9)
Find one that has a macOS installer, not just the tarball
All the defaults are OK"
read -p "press Enter once it is installed."

echo "Hopefully the installer put it at this path. If next command outputs files, you're good!"
echo "ls output:"
ls /Library/Frameworks/Python.framework/Versions/3.8/bin
read -p "If it's not there, you're on your own good luck. You gotta go find it. Press Enter to continue"

echo "create .zprofile if it doesn't already exist"
if [ -e "~/.zprofile" ]
then
    echo "~/.zprofile exists already"
else
    echo "creating ~/.zprofile"
    touch ~/.zprofile
fi

echo "make sure .zprofile contains these four lines:"
echo 'PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:$PATH"'
echo "alias python='python3'"
echo "alias pip='pip3'"
echo "export PATH"
open ~/.zprofile
read -p "Save, close and reopen terminal, and run the next .sh file."
