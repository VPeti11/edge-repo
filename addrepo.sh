#!/bin/bash

REPO_NAME="edge-repo"
GITLAB_USERNAME="edgedev1"
REPO_URL="https://gitlab.com/edgedev1/edge-repo/-/raw/master/x86_64/"
GPG_KEY_URL="https://gitlab.com/edgedev1/edge-repo/-/raw/master/pub.asc"

cat >> /etc/pacman.conf << EOF 
[edge-repo]
SigLevel = Required DatabaseOptional
Server = https://github.com/VPeti11/edge-repo/raw/refs/heads/staging/x86_64/
EOF

echo "Importing GPG key..."
curl -fsSL ${GPG_KEY_URL} | gpg --dearmor -o /etc/pacman.d/gnupg/${REPO_NAME}-pub.gpg

echo "Adding the GPG key to pacman keyring..."
sudo pacman-key --add /etc/pacman.d/gnupg/${REPO_NAME}-pub.gpg

echo "Signing the GPG key..."
KEY_ID=$(gpg --with-colons /etc/pacman.d/gnupg/${REPO_NAME}-pub.gpg | awk -F: '/^pub/ { print $5 }')
sudo pacman-key --lsign-key "$KEY_ID"

echo "Repository installation complete!"
sudo pacman -Syy
