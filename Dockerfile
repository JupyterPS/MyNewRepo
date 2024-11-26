# Step 1: Use the official Jupyter base notebook image
FROM jupyter/base-notebook:latest

# Step 2: Install necessary system packages and PowerShell
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
    lsb-release \
    && curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc \
    && curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/microsoft-prod.list \
    && apt-get update && apt-get install -y powershell \
    && rm -rf /var/lib/apt/lists/*

# Step 3: Upgrade pip to the latest version
RUN python -m pip install --upgrade pip

# Step 4: Install necessary Python packages
RUN pip install matplotlib

# Step 5: Set up the working directory
WORKDIR /home/jovyan

# Step 6: Switch back to the default Jupyter user
USER ${NB_USER}

# Step 7: Expose the necessary JupyterLab port
EXPOSE 8888

# Step 8: Set the entrypoint to start Jupyter Lab
CMD ["start.sh", "jupyter", "lab", "--NotebookApp.token=''"]
