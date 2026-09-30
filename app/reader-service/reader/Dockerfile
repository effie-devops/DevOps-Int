# Use an official Python runtime as a parent image
FROM python:3.11-slim-bookworm

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set work directory
WORKDIR /app

# NOTE: DB config is injected at runtime as env vars from AWS Secrets Manager
# via the Secrets Store CSI driver (see platform/services/*/secret-provider.yaml
# and the deployment's secretKeyRef entries). We intentionally do NOT bake a
# .env into the image so the real credentials never live in the image layers.

# copy dependancies
COPY requirements.txt .

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    postgresql-client \
    libpq-dev \
    build-essential \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Copy shared and service files
COPY shared/ ./shared/
COPY reader-service/reader/ .

# Give django.sh execute permissions
RUN chmod +x /app/django.sh

# Expose port 8000
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8000/health/ || exit 1

# Run application
ENTRYPOINT ["/app/django.sh"]