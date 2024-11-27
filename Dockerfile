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
    && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install Python packages
RUN pip install matplotlib

# Set up the working directory
WORKDIR /home/jovyan

# Switch back to the default Jupyter user
USER ${NB_USER}

# Expose the necessary JupyterLab port
EXPOSE 8888

# Set the entrypoint to start Jupyter Lab
CMD ["start.sh", "jupyter", "lab", "--NotebookApp.token=''"]

# Reinstall Jupyter notebook and basic packages for compatibility
USER root
RUN python -m pip install --upgrade --no-deps --force-reinstall notebook
RUN python -m pip install --user numpy spotipy scipy matplotlib ipython jupyter pandas sympy nose

# Build JupyterLab
RUN jupyter lab build --dev-build=False --minimize=False

# Install JupyterLab Git and related extensions using pip
RUN python -m pip install jupyterlab-git jupyterlab_github

# Install Jupyter themes and additional Python packages
RUN python -m pip install jupyterthemes numpy spotipy scipy matplotlib ipython jupyter pandas sympy nose ipywidgets

# Install requirements from a requirements.txt file (if available)
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Switch back to the default Jupyter user
USER ${NB_USER}
