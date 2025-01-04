FROM python:3.9-slim

WORKDIR /app

# Install system dependencies for building mpi4py
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libopenmpi-dev \
    openmpi-bin \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

# Install Python dependencies
RUN pip install -r requirements.txt

# Install mpi4py and numpy
RUN pip install mpi4py numpy

EXPOSE 80

ENV NAME=World

CMD ["python", "app.py"]
