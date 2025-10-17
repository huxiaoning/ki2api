FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Set pip index URL
RUN pip config set global.index-url https://pypi.org/simple

# Upgrade pip and clear cache
RUN pip install --upgrade pip && pip cache purge

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app.py token_reader.py entrypoint.sh ./

# Make entrypoint executable
RUN chmod +x entrypoint.sh

# Create .aws directory structure
RUN mkdir -p /root/.aws/sso/cache

# Expose port
EXPOSE 8989

# Health check
HEALTHCHECK --interval=60s --timeout=30s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8989/health || exit 1

# Use entrypoint script for smart startup
CMD ["sh", "-c", "python token_reader.py && python app.py"]
