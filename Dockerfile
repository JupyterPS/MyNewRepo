# Base Image
FROM jupyter/base-notebook:latest

# Switch to root user for system-level installations
USER root

# Install essential system tools and PowerShell
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    gnupg \
    apt-transport-https \
    software-properties-common \
    && curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc \
    && curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/microsoft-prod.list \
    && apt-get update && apt-get install -y powershell \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN python -m pip install --upgrade pip \
    && pip install powershell-kernel matplotlib

# Set up PowerShell kernel for Jupyter
RUN python -m powershell_kernel.install

# Switch back to the default Jupyter user
USER $NB_USER

# Expose Jupyter's default port
EXPOSE 8888

# Command to start Jupyter Lab
CMD ["start.sh", "jupyter", "lab", "--NotebookApp.token=''"]
