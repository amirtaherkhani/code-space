#!/bin/bash

# Clone and install synth-shell
git clone --recursive https://github.com/andresgongora/synth-shell.git
chmod +x synth-shell/setup.sh
cd synth-shell
./setup.sh
sudo apt update
# Install bash-completion
sudo apt install bash-completion -y
sudo apt install bc pciutils -y 

# Ensure bash-completion is sourced
echo "source /etc/profile.d/bash_completion.sh" >> ~/.bashrc
grep -wq '^source /etc/profile.d/bash_completion.sh' ~/.bashrc || echo 'source /etc/profile.d/bash_completion.sh' >> ~/.bashrc
echo "source /etc/profile.d/bash_completion.sh" >> ~/.bashrc

# Install LSDeluxe (lsd)
echo "Installing LSDeluxe (lsd)..."
sudo apt install lsd -y

# Add lsd alias for ls
echo "alias ls='lsd'" >> ~/.bashrc
source ~/.bashrc

# Final message
echo "Synth-shell, bash-completion, and LSDeluxe (lsd) have been successfully installed!"
