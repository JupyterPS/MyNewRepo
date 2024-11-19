# Use the official Jupyter base notebook image
FROM jupyter/base-notebook:latest

# Step 1: Upgrade pip to the latest version
RUN python -m pip install --upgrade pip

# Step 2: Install required dependencies for matplotlib (avoid building from source)
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
    && rm -rf /var/lib/apt/lists/*

# Step 3: Install matplotlib from pre-built wheels (avoid source build)
RUN pip install matplotlib

# Step 4: Install other Python dependencies from requirements.txt
COPY requirements.txt ./requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Step 5: Expose the JupyterLab port
EXPOSE 8888
