# Use an official Python base image
FROM python:3.9-slim

# Install MPI dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    libopenmpi-dev \
    openmpi-bin \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m mpiuser

# Install mpi4py
RUN pip install mpi4py numpy

# Copy the MPI Python script into the container
COPY mpi.py /app/mpi.py
COPY hostfile /hostfile

# Set the working directory
WORKDIR /app

# Change the ownership of the files to the new user
RUN chown -R mpiuser:mpiuser /app

# Switch to the non-root user
USER mpiuser

# Command to run the script
CMD ["mpirun", "--hostfile", "/hostfile", "-np", "4", "python", "mpi.py"]
