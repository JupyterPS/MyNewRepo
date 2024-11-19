FROM jupyter/base-notebook:latest

# Ensure all necessary permissions for apt operations
USER root

# Update and install dependencies for PowerShell
RUN chmod -R 777 /var/lib/apt/lists/ && \
    apt-get clean && apt-get update && apt-get install -y \
    wget apt-transport-https software-properties-common && \
    wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && apt-get install -y powershell && \
    rm -rf /var/lib/apt/lists/*

# Install PowerShell kernel
RUN python3 -m pip install --upgrade pip && \
    python3 -m pip install powershell-kernel && \
    python3 -m powershell_kernel.install

# Switch back to the notebook user
USER $NB_UID
