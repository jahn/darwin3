#!/bin/sh
#SBATCH -J macromol
# SBATCH -p pi_mick
#SBATCH -p mit_preemptable
#SBATCH -x node[2100-2103,2300-2304,3000-3008,3804-3807,3809,3903-3905,3100]
#SBATCH -n 144
#SBATCH --mem-per-cpu 4000
# SBATCH --exclusive

. /etc/profile.d/modules.sh
module load gcc/12.2.0
module load openmpi/4.1.4
module load netcdf-c/4.9.2
module load netcdf-fortran/4.6.1
export MPI_INC_DIR=/orcd/software/core/001/spack/pkg/openmpi/4.1.4/zahpnmk/include
export LD_LIBRARY_PATH=/orcd/software/community/001/spack/pkg/netcdf-c/4.9.2/2uroesk/lib:/orcd/software/community/001/spack/pkg/netcdf-fortran/4.6.1/gxllmsl/lib:$LD_LIBRARY_PATH

#lfs setstripe -c -1 .

mpirun -n 144 ./mitgcmuv

tail STDOUT.0000 | grep -q "Execution ended Normally" || exit 1

ckpt="$( grep ' %CHECKPOINT' STDOUT.0000 | tail -n 1 )"
if [ -n "$ckpt" ]; then
    echo "Last checkpoint: $ckpt"
fi
