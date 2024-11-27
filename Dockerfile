# Step 1: Use the official Jupyter base notebook image
FROM jupyter/base-notebook:latest

# Step 2: Install necessary system packages (including PowerShell)
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
    #&& curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc \
    #&& curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/microsoft-prod.list \
    #&& apt-get update && apt-get install -y powershell \
    #&& rm -rf /var/lib/apt/lists/*

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

# Step 10: Install Jupyter notebook, Git, themes, and additional packages for compatibility
USER root

RUN python -m pip install --upgrade --no-deps --force-reinstall notebook
RUN python -m pip install --user numpy spotipy scipy matplotlib ipython jupyter pandas sympy nose

# Step 11: Build JupyterLab
RUN jupyter lab build --dev-build=False --minimize=False

# Step 12: Install JupyterLab Git and related extensions using pip
RUN python -m pip install jupyterlab-git jupyterlab_github

# Step 13: Install Jupyter themes and additional Python packages
RUN python -m pip install jupyterthemes numpy spotipy scipy matplotlib ipython jupyter pandas sympy nose ipywidgets

# Step 14: Install requirements from a requirements.txt file (if available)
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Step 15: Install PowerShell kernel for Jupyter and create necessary directories
RUN pip install powershell-kernel && \
    mkdir -p /home/jovyan/.local/share/jupyter/kernels && \
    python -m powershell_kernel.install && \
    chown -R ${NB_UID}:${NB_UID} /home/jovyan/.local/share/jupyter/kernels

# Step 16: Switch back to the default Jupyter user
USER ${NB_USER}
