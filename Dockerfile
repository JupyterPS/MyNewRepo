# Use the official Jupyter base notebook image
FROM jupyter/base-notebook:latest

# Install necessary system packages
USER root
RUN apt-get update && apt-get install -y \
    build-essential \
    libfreetype6-dev \
    libpng-dev \
    libblas-dev \
    liblapack-dev \
    gfortran \
    pkg-config \
    libharfbuzz-dev \
    libfribidi-dev \
    curl \
    gnupg \
    lsb-release

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install Python packages
RUN pip install matplotlib

# Install PowerShell separately
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc \
    && curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/microsoft-prod.list \
    && apt-get update && apt-get install -y powershell \
    && rm -rf /var/lib/apt/lists/*

# Set up the working directory
WORKDIR /home/jovyan

# Switch back to the default Jupyter user
USER ${NB_USER}

# Expose the necessary JupyterLab port
EXPOSE 8888

# Set the entrypoint to start Jupyter Lab
CMD ["start.sh", "jupyter", "lab", "--NotebookApp.token=''"]
