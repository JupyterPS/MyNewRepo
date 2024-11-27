# Use the official PowerShell image
FROM mcr.microsoft.com/powershell:ubuntu-20.04

# Install Python 3
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

# Verify Python installation
RUN python3 --version || echo "Python installation failed"

# Set the default command to start PowerShell
CMD ["pwsh"]



