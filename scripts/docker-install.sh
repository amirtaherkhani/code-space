#!/bin/bash

# Check if Docker is installed
if [ $(dpkg -l | grep docker-ce | wc -l) -eq 0 ]; then
    # Docker is not installed, run the installation script
    echo "Docker is not installed. Installing Docker..."
    # Update package list
    sudo apt update

    # Install dependencies
    sudo apt install -y ca-certificates curl

    # Create directory for Docker GPG key
    sudo install -m 0755 -d /etc/apt/keyrings

    # Download Docker GPG key
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

    # Make Docker GPG key readable
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    # Add Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update package list again
    sudo apt update

    # Install Docker and its dependencies
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Create docker group
    sudo groupadd docker

    # Add current user to docker group
    sudo usermod -aG docker $USER
    
    #Create docker  dir for current user
    mkdir $HOME/.docker
    
    # Change ownership and permissions of .docker directory
    sudo chown "$USER":"$USER" $HOME/.docker -R
    sudo chmod g+rwx "$HOME/.docker" -R

    # Enable Docker to start on boot
    sudo systemctl enable docker
    sudo systemctl enable containerd


    # Start Docker service
    sudo systemctl start docker

    # Log out and log back in to re-evaluate group membership
    echo "Please log out and log back in to re-evaluate group membership."

    # Test Docker installation
    docker run hello-world

    # Print Docker version
    docker --version

    echo "Docker has been installed and configured successfully."
    echo "Docker will start automatically on system boot."
else
    # Docker is already installed, inform the user
    echo "Docker is already installed. No action required."
fi