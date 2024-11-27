# Use an Ubuntu base image
FROM ubuntu:20.04

# Install necessary system packages, including apt-utils, and PowerShell
RUN apt-get update && apt-get install -y \
    apt-utils \
    wget \
    apt-transport-https \
    software-properties-common \
    && wget -q https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell

# Verify PowerShell installation
RUN pwsh -version || echo "PowerShell installation failed"

# Default command to start PowerShell
CMD ["pwsh"]
