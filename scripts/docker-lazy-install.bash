#!/bin/bash

# Allow specifying different destination directory
DIR="${DIR:-"$HOME/.local/bin"}"

# Map different architecture variations to the available binaries
ARCH=$(uname -m)
case $ARCH in
    i386|i686) ARCH=x86 ;;
    armv6*) ARCH=armv6 ;;
    armv7*) ARCH=armv7 ;;
    aarch64*) ARCH=arm64 ;;
esac

# Prepare the download URL
GITHUB_LATEST_VERSION=$(curl -L -s -H 'Accept: application/json' https://github.com/jesseduffield/lazydocker/releases/latest | sed -e 's/.*"tag_name":"\([^"]*\)".*/\1/')
GITHUB_FILE="lazydocker_${GITHUB_LATEST_VERSION//v/}_$(uname -s)_${ARCH}.tar.gz"
GITHUB_URL="https://github.com/jesseduffield/lazydocker/releases/download/${GITHUB_LATEST_VERSION}/${GITHUB_FILE}"

# Install/update the local binary
echo "Downloading LazyDocker..."
curl -L -o lazydocker.tar.gz "$GITHUB_URL"
tar xzvf lazydocker.tar.gz lazydocker
install -Dm 755 lazydocker -t "$DIR"
rm lazydocker lazydocker.tar.gz
echo "LazyDocker installed successfully!"

# Ensure ~/.local/bin is in PATH
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.bashrc; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# Add "docker lazy" function to ~/.bashrc (or ~/.zshrc for Zsh users)
SHELL_CONFIG="$HOME/.bashrc"
if [[ "$SHELL" =~ "zsh" ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
fi

if ! grep -q 'docker() { if [ "$1" = "lazy" ]; then lazydocker; else command docker "$@"; fi; }' "$SHELL_CONFIG"; then
    echo -e '\n# Alias for LazyDocker\ndocker() { if [ "$1" = "lazy" ]; then lazydocker; else command docker "$@"; fi; }' >> "$SHELL_CONFIG"
    echo "Added 'docker lazy' command to $SHELL_CONFIG"
fi

# Reload shell configuration
source "$SHELL_CONFIG"

echo "Installation complete! Run 'docker lazy' to start LazyDocker."
