#!/bin/bash

# Default settings
NODE_VERSION="22"  # Default Node.js version (20, 22, or 24)
INSTALL_YARN=false
INSTALL_PNPM=false
INSTALL_TYPESCRIPT=false
NVM="v0.40.1"

# Help message
show_help() {
  echo "Usage: ./node-install.sh [options]"
  echo ""
  echo "Options:"
  echo "  -n, -v, --node-version    Specify Node.js version to install (default: ${NODE_VERSION})"
  echo "  -y, --install-yarn         Install Yarn package manager"
  echo "  -p, --install-pnpm         Install pnpm package manager"
  echo "  -t, --install-typescript   Install TypeScript and related packages"
  echo "  -h, --help                 Show this help message and exit"
  echo ""
  echo "Example:"
  echo "  ./node-install.sh -n 18 -y -t"
}

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -n| -v|--node-version)
            NODE_VERSION="$2"
            shift
            ;;
        -y|--install-yarn)
            INSTALL_YARN=true
            ;;
        -p|--install-pnpm)
            INSTALL_PNPM=true
            ;;
        -t|--install-typescript)
            INSTALL_TYPESCRIPT=true
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown parameter passed: $1"
            show_help
            exit 1
            ;;
    esac
    shift
done

# Update package lists
echo "Updating package lists..."
sudo apt update

# Install prerequisites
echo "Installing prerequisites..."
sudo apt install -y curl build-essential
sudo apt remove nodejs -y 
sudo apt remove libnode72 -y 

# Install Node.js
echo "Installing Node.js version ${NODE_VERSION}..."
curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION%.*}.x | sudo -E bash -
sudo apt-get install -y nodejs

wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM}/install.sh | bash

# Verify Node.js installation
echo "Node.js version installed:"
node -v
npm install -g npm

# Install ESLint for linting
npm install -g eslint

# Install Prettier for code formatting
npm install -g prettier

# Install Nodemon for auto-restarting Node.js apps
npm install -g nodemon

# Install Yarn if selected
if [ "$INSTALL_YARN" = true ]; then
    echo "Installing Yarn..."
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
    sudo apt update && sudo apt install -y yarn
    echo "Yarn version installed:"
    yarn -v
fi

# Install pnpm if selected
if [ "$INSTALL_PNPM" = true ]; then
    echo "Installing pnpm..."
    npm install -g pnpm
    echo "pnpm version installed:"
    pnpm -v
fi

# Install TypeScript and related packages if selected
if [ "$INSTALL_TYPESCRIPT" = true ]; then
    echo "Installing TypeScript and related packages..."

    # Install TypeScript compiler
    npm install -g typescript

    # Install ts-node for running TypeScript directly
    npm install -g ts-node
    
    # Install npm-check-updates for updating dependencies
    npm install -g npm-check-updates

    echo "Installed global packages:"
    echo "- TypeScript: $(tsc -v)"
    echo "- ts-node: $(ts-node -v)"
    echo "- ESLint: $(eslint -v)"
    echo "- Prettier: $(prettier -v)"
    echo "- Nodemon: $(nodemon -v)"
    echo "- npm-check-updates: $(ncu -v)"
fi

sudo apt-get autoremove -y  
sudo apt-get autoclean -y 
echo "Installation completed successfully!"
