#!/bin/bash

REPO_NAME="edge-repo"
GITLAB_USERNAME="VPeti11"

# Default URLs (master branch)
REPO_URL_GITLAB="https://gitlab.com/edgedev1/edge-repo/-/raw/master/x86_64/"
REPO_URL_GITHUB="https://github.com/VPeti11/edge-repo/raw/refs/heads/master/x86_64/"
# GPG key always from master
GPG_KEY_URL="https://github.com/VPeti11/edge-repo/-/raw/master/pub.asc"

echo -n "Do you want to enable staging repos? (y/N): "
read -r enable_staging

if [[ "$enable_staging" =~ ^[Yy]$ ]]; then
    echo "Using staging repos..."
    REPO_CONF=$(cat <<EOF
[edge-repo]
SigLevel = Required DatabaseOptional
Server = https://github.com/VPeti11/edge-repo/raw/refs/heads/staging/x86_64/
EOF
)
else
    echo "Using stable repos..."
    REPO_CONF=$(cat <<EOF
[edge-repo]
SigLevel = Required DatabaseOptional
Server = ${REPO_URL_GITLAB}
Server = ${REPO_URL_GITHUB}
EOF
)
fi

# Append repo config
cat >> /etc/pacman.conf <<< "$REPO_CONF"

echo "Importing GPG key..."
curl -fsSL ${GPG_KEY_URL} | gpg --dearmor -o /etc/pacman.d/gnupg/${REPO_NAME}-pub.gpg

echo "Adding the GPG key to pacman keyring..."
sudo pacman-key --add /etc/pacman.d/gnupg/${REPO_NAME}-pub.gpg

echo "Signing the GPG key..."
KEY_ID=$(gpg --with-colons /etc/pacman.d/gnupg/${REPO_NAME}-pub.gpg | awk -F: '/^pub/ { print $5 }')
sudo pacman-key --lsign-key "$KEY_ID"

echo "Repository installation complete!"
sudo pacman -Syy
