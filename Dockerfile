# Step 1: Use the official Jupyter base notebook image
FROM jupyter/base-notebook:latest

# Step 2: Upgrade pip to the latest version
RUN python -m pip install --upgrade pip

# Step 3: Install required build dependencies (setuptools, wheel, etc.)
RUN pip install setuptools wheel setuptools_scm

# Step 4: Install required Python dependencies from requirements.txt
COPY requirements.txt ./requirements.txt
RUN pip install --use-pep517 --no-cache-dir -r requirements.txt

# Step 5: Install matplotlib separately to avoid any build issues
RUN pip install matplotlib

# Step 6: Install additional libraries and tools
RUN apt-get update && apt-get install -y \
    curl \
    powershell \
    libicu66

# Step 7: Install JupyterLab extensions and other Python packages
RUN pip install jupyterlab_github
RUN pip install jupyterlab-git
RUN jupyter labextension install @jupyterlab/git

# Step 8: Install .NET CLI dependencies for .NET Core SDK
RUN apt-get install -y \
    libc6 \
    libgcc1 \
    libgssapi-krb5-2 \
    libssl1.1 \
    libstdc++6 \
    zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Step 9: Install .NET Core SDK
RUN dotnet_sdk_version=3.1.301 \
    && curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-$dotnet_sdk_version-linux-x64.tar.gz \
    && dotnet_sha512='dd39931df438b8c1561f9a3bdb50f72372e29e5706d3fb4c490692f04a3d55f5acc0b46b8049bc7ea34dedba63c71b4c64c57032740cbea81eef1dce41929b4e' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -ozxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && dotnet help

# Step 10: Copy custom notebooks, configuration files, and sources
COPY ./config ${HOME}/.jupyter/
COPY ./ ${HOME}/Notebooks/
COPY ./NuGet.config ${HOME}/nuget.config

# Step 11: Set user-related environment variables
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

# Step 12: Switch to root user to install additional dependencies (if needed)
USER root
RUN apt-get update && apt-get install -y curl

# Step 13: Install nteract for Jupyter (for enhanced notebook interaction)
RUN pip install nteract_on_jupyter

# Step 14: Install .NET Interactive globally for .NET notebooks
RUN dotnet tool install --global Microsoft.dotnet-interactive --version 1.0.155302 --add-source "https://dotnet.myget.org/F/dotnet-try/api/v3/index.json"

# Step 15: Update PATH with .NET tools directory
ENV PATH="${PATH}:${HOME}/.dotnet/tools"

# Step 16: Install Jupyter Kernel for .NET Interactive
RUN dotnet interactive jupyter install

# Step 17: Enable telemetry after installing Jupyter
ENV DOTNET_TRY_CLI_TELEMETRY_OPTOUT=false

# Step 18: Set the working directory for notebooks
WORKDIR ${HOME}/Notebooks/

# Final Step: Expose port for JupyterLab
EXPOSE 8888
