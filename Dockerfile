# Use the working base image
FROM jupyter/base-notebook:latest

# Steps 2-9 from the previous successful Dockerfile
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

RUN python -m pip install --upgrade pip
RUN pip install matplotlib

WORKDIR /home/jovyan
USER ${NB_USER}
EXPOSE 8888
CMD ["start.sh", "jupyter", "lab", "--NotebookApp.token=''"]

# Step 10: Reinstall Jupyter notebook and basic packages for compatibility
USER root
RUN python -m pip install --upgrade --no-deps --force-reinstall notebook
RUN python -m pip install --user numpy spotipy scipy matplotlib ipython jupyter pandas sympy nose
