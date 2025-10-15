# Selecting a base image with python pre-installed
FROM python:3.11-slim

# Set working directory within container
WORKDIR /app

# Copy requirements.txt file to container and install them
COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Copy everthing from app directory to container
COPY app/ .

# Documentation to remember what port to expose
EXPOSE 5000

# When container spins up start the server
CMD ["python", "application.py"]
