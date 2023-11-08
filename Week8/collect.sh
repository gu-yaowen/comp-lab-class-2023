sbatch --time=02:00:00 --mem=1GB --wrap "sleep infinity"

srun --cpus-per-task=8 --mem=8GB --time=4:00:00 --pty /bin/bash

source /scratch/work/courses/CHEM-GA-2671-2023fa/software/lammps-gcc-30Oct2022/setup_lammps.bash
cp -r /scratch/work/courses/CHEM-GA-2671-2023fa/software/lammps-gcc-30Oct2022/examples/melt/ Inputs/

cd Inputs/melt
mpirun lmp -in in.melt

module load imagemagick/intel/7.0.10
vmd -lammpstrj dump.melt -log LOGFILE -var VAR

mpirun lmp -var density 0.5  -in ../Inputs/2dWCA.in
vmd 2dWCA_T0.1_d0.5_N100000.lammpstrj 2dWCA_T0.1_d0.5_N100000.dcd

for nv in 0.5 0.6 0.7 0.8 0.9 1.0 1.1; do
    mpirun lmp -var density $nv -in Inputs/2dWCA.in
done


for nv in 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5; do
    mkdir Data/3D_WCA_${nv}
    logfile=Data/3D_WCA_${nv}/log_${nv}.log
    mpirun lmp -var density $nv -in Inputs/3dWCA.in -log $logfile
done

mpirun lmp -var density 0.95 -in Inputs/2dWCA.in

vmd 2dWCA_T0.1_d0.5_N100000.lammpstrj 2dWCA_T0.1_d0.5_N100000.dcd

# "/share/apps/vmd/1.9.3/lib/vmd/tachyon_LINUXAMD64" -aasamples 12 %s -format BMP -res 1024 1024  -o %s.bmp

# vmd 2dWCA_T0.1_d${nv}_N100000.lammpstrj 2dWCA_T0.1_d${nv}_N100000.dcd