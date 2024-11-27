# Use the official PowerShell image
FROM mcr.microsoft.com/powershell:ubuntu-20.04

# Install Python 3 and essential build tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    build-essential

# Set environment variables if needed
ENV PATH="/usr/local/bin/python3:$PATH"

# Clean up APT when done
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Verify installations
RUN pwsh -version && python3 --version

# Default command to start PowerShell
CMD ["pwsh"]


