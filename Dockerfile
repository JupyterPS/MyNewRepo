# Step 1: Use the official Jupyter base notebook image
FROM jupyter/base-notebook:latest

# Step 2: Install necessary system packages (including PowerShell)
USER root

# Step 3: Install necessary packages
RUN apt-get update && apt-get install -y \
    powershell \
    && rm -rf /var/lib/apt/lists/*

# Step 4: Upgrade pip
RUN python -m pip install --upgrade pip

# Step 5: Install necessary Python packages
RUN pip install matplotlib

# Step 6: Set up the working directory
WORKDIR /home/jovyan

# Step 7: Switch back to the default Jupyter user
USER ${NB_USER}

# Step 8: Expose the necessary JupyterLab port
EXPOSE 8888

# Step 9: Set the entrypoint to start Jupyter Lab
CMD ["start.sh", "jupyter", "lab", "--NotebookApp.token=''"]
