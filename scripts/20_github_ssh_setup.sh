#! /bin/bash

echo "Setting up connection to git with SSH"
read -p "Please insert your github e-mail " MAIL
ssh-keygen -t ed25519 -C "$MAIL"
eval "$(ssh-agent -s)"

echo "create ssh config file if it doesn't already exist"
if [ -e "~/.ssh/config" ]
then
    echo "~/.ssh/config exists already"
else
    echo "creating ~/.ssh/config"
    touch ~/.ssh/config
fi

echo "adding standard info to ssh file"

cat <<EOF > ~/.ssh/config
Host *.github.com
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_ed25519
EOF

echo "do something which I don't know what is"
ssh-add --apple-use-keychain ~/.ssh/id_ed25519

echo "copy SSH public key to clipboard"
pbcopy < ~/.ssh/id_ed25519.pub

echo ""
echo "SSH public key copied to clipboard. This should be added to https://github.com/settings/ssh/new."
echo "In the 'Title' field, add a descriptive label for the new key. For example, if you're using a personal laptop, you might call this key 'Personal laptop'. Paste the key from the clipboard into the key field"
read -s -p "Press enter to open this website"
open https://github.com/settings/ssh/new
read -s -p "Press enter once the keys have been added"
echo ""

echo "testing connection. Expecting message: > Hi USERNAME! You've successfully authenticated, but GitHub does not provide shell access."
ssh -T git@github.com
