# Step 1: Use the official Jupyter base notebook image
FROM jupyter/base-notebook:latest

# Step 2: Install necessary system packages (including PowerShell)
USER root

# Step 3: Install necessary packages, including curl and apt dependencies
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

# Step 4: Install PowerShell by adding the Microsoft repository
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc \
    && curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/microsoft-prod.list \
    && apt-get update && apt-get install -y powershell \
    && rm -rf /var/lib/apt/lists/*

# Step 5: Upgrade pip to the latest version
RUN python -m pip install --upgrade pip

# Reinstall Jupyter notebook for compatibility
RUN python -m pip install --upgrade --no-deps --force-reinstall notebook
RUN python -m pip install --user numpy spotipy scipy matplotlib ipython jupyter pandas sympy nose

RUN jupyter lab build 
# Install JupyterLab Git and related extensions
#RUN python -m pip install jupyterlab-git jupyterlab_github
#RUN jupyter labextension install @jupyterlab/git

#Working Directory
# Install Jupyter themes and additional Python packages
RUN python -m pip install jupyterthemes numpy spotipy scipy matplotlib ipython jupyter pandas sympy nose ipywidgets

# Set up the working directory
WORKDIR $HOME

# Set up user and home environment variables
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

# Change to root user to install system dependencies
USER root
 
    
# Install .NET CLI dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu66 \
        libssl1.1 \
        libstdc++6 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*
    
# Install .NET Core SDK
RUN dotnet_sdk_version=3.1.301 \
    && curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-$dotnet_sdk_version-linux-x64.tar.gz \
    && dotnet_sha512='dd39931df438b8c1561f9a3bdb50f72372e29e5706d3fb4c490692f04a3d55f5acc0b46b8049bc7ea34dedba63c71b4c64c57032740cbea81eef1dce41929b4e' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -ozxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help
    

# Step 6: Install the PowerShell Jupyter kernel
RUN pip install powershell-kernel

# Step 7: Install any additional Python dependencies (e.g., matplotlib)
RUN pip install matplotlib

# Step 8: Install requirements from a requirements.txt file (if available)
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Step 9: Setup PowerShell kernel (automatically runs when the container starts)
RUN python -m powershell_kernel.install

# Step 10: Switch back to the default Jupyter user
USER $NB_USER

# Step 11: Expose the necessary JupyterLab port
EXPOSE 8888

# Step 12: Set the entrypoint to start Jupyter Lab with PowerShell available as a kernel
CMD ["start.sh", "jupyter", "lab", "--NotebookApp.token=''"]
 
