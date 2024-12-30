# Use a minimal Python base image
FROM python:3.9-slim

# Set the working directory
WORKDIR /app

# Copy requirements and application code
COPY requirements.txt requirements.txt
COPY app.py app.py

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose the application port
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]
