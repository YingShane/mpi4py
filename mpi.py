from mpi4py import MPI
import numpy as np
import time

# Initialize MPI
comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()

# Record start time
start_time = MPI.Wtime()

# Number of elements to calculate (only on rank 0)
if rank == 0:
    data = np.arange(1, 1000001)
    chunk_size = len(data) // size
    chunks = [data[i * chunk_size: (i + 1) * chunk_size] for i in range(size)]
else:
    chunks = None

# Scatter chunks to all processes
local_data = comm.scatter(chunks, root=0)

# Calculate local sum and count
local_sum = np.sum(local_data)
local_count = len(local_data)

# Gather local sums and counts to rank 0
total_sum = comm.reduce(local_sum, op=MPI.SUM, root=0)
total_count = comm.reduce(local_count, op=MPI.SUM, root=0)

# Record end time
end_time = MPI.Wtime()

# Calculate average on rank 0
if rank == 0:
    average = total_sum / total_count
    print(f"Total Sum: {total_sum}")
    print(f"Average: {average}")
    print(f"Execution Time: {end_time - start_time:.6f} seconds")
