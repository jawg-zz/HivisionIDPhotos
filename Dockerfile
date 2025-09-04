FROM python:3.10-slim

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    ffmpeg \
    libgl1 \
    libglib2.0-0 \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy requirements files first for better caching
COPY requirements.txt requirements-app.txt ./

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt -r requirements-app.txt

# Copy the entire project
COPY . .

# Create weights directory
RUN mkdir -p hivision/creator/weights

# Download model weights using the provided script
RUN python scripts/download_model.py --models all

# Expose the required ports
EXPOSE 7860
EXPOSE 8080

# Run the application
CMD ["python3", "-u", "app.py", "--host", "0.0.0.0", "--port", "7860"]
