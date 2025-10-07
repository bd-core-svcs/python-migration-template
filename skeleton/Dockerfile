FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Create non-root user
RUN useradd -m -u 1000 litellm && chown -R litellm:litellm /app
USER litellm

# Expose port
EXPOSE ${{ values.port }}

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${{ values.port }}/health || exit 1

# Run the application
CMD ["python", "-m", "litellm", "--config", "litellm-config.yaml", "--port", "${{ values.port }}", "--host", "0.0.0.0"]
