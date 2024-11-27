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
    lsb-release

# Upgrade pip
RUN python -m pip install --upgrade pip

# Install minimal Python packages
RUN pip install matplotlib

# Set up the working directory
WORKDIR /home/jovyan

# Switch back to the default Jupyter user
USER ${NB_USER}

# Expose the necessary JupyterLab port
EXPOSE 8888

# Set the entrypoint to start Jupyter Lab
CMD ["start.sh", "jupyter", "lab", "--NotebookApp.token=''"]
