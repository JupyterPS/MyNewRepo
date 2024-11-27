# Reinstall Jupyter notebook and additional packages
USER root
RUN python -m pip install --upgrade --no-deps --force-reinstall notebook
RUN python -m pip install --user numpy spotipy scipy matplotlib ipython jupyter pandas sympy nose

# Build JupyterLab
RUN jupyter lab build --dev-build=False --minimize=False

# Install JupyterLab Git and related extensions
RUN python -m pip install jupyterlab-git jupyterlab_github

# Install Jupyter themes and additional Python packages
RUN python -m pip install jupyterthemes numpy spotipy scipy matplotlib ipython jupyter pandas sympy nose ipywidgets

# Install requirements from a requirements.txt file (if available)
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install PowerShell kernel for Jupyter
RUN pip install powershell-kernel --no-cache-dir && \
    mkdir -p /home/jovyan/.local/share/jupyter/kernels && \
    python -m powershell_kernel.install && \
    chown -R ${NB_UID}:${NB_UID} /home/jovyan/.local/share/jupyter/kernels
