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
    lsb-release \
    git \
    iputils-ping \
    traceroute \
    apt-transport-https \
    software-properties-common \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
    && curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/microsoft-prod.list \
    && apt-get update \
    && apt-get install -y powershell \
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install matplotlib
RUN pip install matplotlib

# Set up the working directory
WORKDIR /home/jovyan

# Switch back to the default Jupyter user
USER ${NB_USER}

# Expose the necessary JupyterLab port
EXPOSE 8888

# Set the entrypoint to start Jupyter Lab
CMD ["start.sh", "jupyter", "lab", "--NotebookApp.token=''"]

# Install numpy and scipy using conda
USER root
RUN conda install -y numpy scipy

# Install spotipy using pip
RUN pip install spotipy

# Install ipython, jupyter, pandas, sympy, nose, and ipywidgets using pip
RUN pip install ipython jupyter pandas sympy nose ipywidgets

# Build JupyterLab
RUN jupyter lab build --dev-build=False --minimize=False

# Install JupyterLab Git and related extensions using pip
RUN python -m pip install jupyterlab-git jupyterlab_github

# Install Jupyter themes and additional Python packages
RUN pip install jupyterthemes

# Install requirements from a requirements.txt file (if available)
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Verify PowerShell installation
RUN pwsh -version || echo "PowerShell installation failed"
