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
