# Use a base image with Python and Jupyter pre-installed
FROM jupyter/base-notebook:python-3.10

# Install PowerShell
RUN apt-get update && \
    apt-get install -y wget apt-transport-https software-properties-common && \
    wget -q https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install -y powershell && \
    rm -rf /var/lib/apt/lists/*

# Install PowerShell Jupyter kernel
RUN pip install powershell-kernel && \
    python -m powershell_kernel.install

# Expose default JupyterLab port
EXPOSE 8888

# Start JupyterLab
CMD ["start-notebook.sh"]
