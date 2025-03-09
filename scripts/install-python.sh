#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
NC='\033[0m' # No Color

# Update and upgrade the system
echo -e "${YELLOW}Updating and upgrading the system...${NC}"
sudo apt update && sudo apt upgrade -y

# Install dependencies for building Python
echo -e "${YELLOW}Installing dependencies...${NC}"
sudo apt install -y build-essential libssl-dev \
    libsqlite3-dev zlib1g-dev libffi-dev python3-venv python3-pip pipx

# Ensure pipx is installed
echo -e "${YELLOW}Installing pipx...${NC}"
sudo apt install -y pipx
pipx ensurepath

# Add the deadsnakes PPA for the latest Python versions
echo -e "${YELLOW}Adding deadsnakes PPA...${NC}"
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt update

# Install Python 3.12
echo -e "${YELLOW}Installing Python 3.12...${NC}"
sudo apt install -y python3.12 python3.12-venv python3-pip

# Ensure pip is upgraded to the latest version
echo -e "${YELLOW}Upgrading pip with --break-system-packages...${NC}"
python3.12 -m pip install --upgrade pip --break-system-packages

# Ensure pipx is available
echo -e "${YELLOW}Ensuring pipx is available...${NC}"
export PATH="$HOME/.local/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Create a virtual environment and install essential Python packages
echo -e "${YELLOW}Setting up a virtual environment for essential Python packages...${NC}"
python3.12 -m venv ~/python_env
source ~/python_env/bin/activate
pip install setuptools wheel requests uv

deactivate

# Install uv (https://github.com/astral-sh/uv)
echo -e "${YELLOW}Installing uv...${NC}"
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv and pipx binaries to PATH if not already present
echo -e "${YELLOW}Updating PATH...${NC}"
export PATH="$HOME/.local/bin:$HOME/.local/pipx/venvs/bin:$PATH"
echo 'export PATH="$HOME/.local/bin:$HOME/.local/pipx/venvs/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc

# Verify installations
echo -e "${BLUE}Verifying installations...${NC}"
echo -e "${GREEN}Python version:${NC} $(python3.12 --version)"
echo -e "${GREEN}Pip version:${NC} $(python3.12 -m pip --version)"
echo -e "${GREEN}Virtualenv version:${NC} $(~/python_env/bin/python -m virtualenv --version)"
echo -e "${GREEN}uv version:${NC} $(uv --version)"
echo -e "${GREEN}Installed Python packages in virtual environment:${NC}"
source ~/python_env/bin/activate
pip list

deactivate

# Final message
echo -e "${GREEN}Python 3.12, pip, virtualenv, uv, and essential Python packages have been successfully installed in a virtual environment!${NC}"
