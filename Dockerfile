# Use a lightweight Python image
FROM python:3.11-slim

# Install system dependencies for dbt and DuckDB
RUN apt-get update && apt-get install -y \
    git \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Set the working directory
WORKDIR /opt/dagster/app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Create a directory for Dagster metadata
RUN mkdir -p /opt/dagster/dagster_home
ENV DAGSTER_HOME=/opt/dagster/dagster_home

# Expose the ports for the 3 services
EXPOSE 3000 8000 8501