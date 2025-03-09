# Use the linuxserver/code-server image as the base
FROM lscr.io/linuxserver/code-server:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV INSTALL_PACKAGES="wget curl build-essential openssl"

# Ensure apt package list is updated before installing
RUN apt-get update && \
    apt-get install -y $INSTALL_PACKAGES && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy scripts from the local scripts directory to the container
COPY scripts/ /tmp/scripts/

# Grant execution permissions to all scripts
RUN chmod +x /tmp/scripts/*.sh

# Switch to user abc
USER abc

# Execute installation scripts (excluding mybash.sh initially)
RUN /tmp/scripts/docker-install.sh && rm -f /tmp/scripts/docker-install.sh
RUN /tmp/scripts/install-python.sh && rm -f /tmp/scripts/install-python.sh
RUN /tmp/scripts/node-install.sh && rm -f /tmp/scripts/node-install.sh
RUN /tmp/scripts/docker-lazy-install.bash && rm -f /tmp/scripts/docker-lazy-install.bash

# Ensure mybash.sh is executed last
RUN /tmp/scripts/mybash.sh && rm -f /tmp/scripts/mybash.sh

# Switch back to root user
USER root

# Expose default code-server port
EXPOSE 8443

# Start the container
CMD ["/init"]
