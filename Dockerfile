FROM jupyter/base-notebook:latest

# Install PowerShell
RUN apt-get update && apt-get install -y \
    wget apt-transport-https software-properties-common \
    && wget -q https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y powershell \
    && rm -rf /var/lib/apt/lists/*

# Install PowerShell kernel
RUN python -m pip install powershell-kernel && python -m powershell_kernel.install
