# Use the official PowerShell image
FROM mcr.microsoft.com/powershell:latest

# Install necessary system packages
USER root
RUN apt-get update && apt-get install -y \
    wget \
    apt-transport-https \
    software-properties-common \
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
    lsb-release \
    git \
    iputils-ping \
    traceroute \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install matplotlib
RUN pip install matplotlib

# Set up the working directory
WORKDIR /workspace

# Expose the necessary port
EXPOSE 8888

# Install numpy and scipy using pip
RUN pip install numpy scipy

# Install additional packages
RUN pip install spotipy ipython jupyter pandas sympy nose ipywidgets jupyterthemes jupyterlab-git jupyterlab_github

# Copy requirements.txt if available
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Default command to start PowerShell
CMD ["pwsh"]
