# Step 1: Start from Jupyter base notebook
FROM jupyter/base-notebook:latest

# Step 2: Upgrade pip and install required dependencies
RUN python -m pip install --upgrade pip
COPY requirements.txt ./requirements.txt
RUN python -m pip install -r requirements.txt
RUN python -m pip install --upgrade --no-deps --force-reinstall notebook

# Step 3: Install JupyterLab extensions
RUN python -m pip install jupyterlab_github
RUN python -m pip install jupyterlab-git

# Install PowerShell and .NET SDK
RUN apt-get update && apt-get install -y curl powershell

# Step 4: Install .NET Core SDK and .NET Interactive
RUN dotnet_sdk_version=3.1.301 \
    && curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-$dotnet_sdk_version-linux-x64.tar.gz \
    && dotnet_sha512='dd39931df438b8c1561f9a3bdb50f72372e29e5706d3fb4c490692f04a3d55f5acc0b46b8049bc7ea34dedba63c71b4c64c57032740cbea81eef1dce41929b4e' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -ozxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Step 5: Install .NET Interactive Jupyter kernel
RUN dotnet tool install --global Microsoft.dotnet-interactive --version 1.0.155302
RUN dotnet interactive jupyter install

# Step 6: Set user-related environment variables
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

# Step 7: Copy necessary configuration and script files
COPY ./config ${HOME}/.jupyter/
COPY ./ ${HOME}/WindowsPowerShell/
COPY ./NuGet.config ${HOME}/nuget.config

# Step 8: Set the working directory to Notebooks
WORKDIR ${HOME}/WindowsPowerShell/

# Step 9: Fix permissions and set the user back to jovyan
RUN chown -R ${NB_UID} ${HOME}
USER ${USER}

# Step 10: Install nteract for Jupyter
RUN pip install nteract_on_jupyter

# Step 11: Install any remaining Python dependencies
RUN python -m pip install --user numpy spotipy scipy matplotlib ipython jupyter pandas sympy nose

# Step 12: Enable telemetry after installing Jupyter
ENV DOTNET_TRY_CLI_TELEMETRY_OPTOUT=false

# Step 13: Set the working directory to Notebooks
WORKDIR ${HOME}/WindowsPowerShell/

# Final step: Set the entry point (optional depending on your setup)
CMD ["start-notebook.sh"]
