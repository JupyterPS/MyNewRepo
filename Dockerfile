FROM jupyter/base-notebook:python-3.10

USER root

# Install dependencies and PowerShell
RUN apt-get update && \
    apt-get install --no-install-recommends -y wget apt-transport-https software-properties-common && \
    wget -q https://packages.microsoft.com/config/debian/11/packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    apt-get update && \
    apt-get install --no-install-recommends -y powershell && \
    rm -rf /var/lib/apt/lists/*

USER ${NB_UID}

# Install JupyterLab and PowerShell kernel
RUN pip install jupyterlab powershell-kernel && \
    python -m powershell_kernel.install

# Ensure Binder compatibility
ENV JUPYTER_ENABLE_LAB=yes
WORKDIR /home/jovyan

CMD ["start-notebook.sh"]
