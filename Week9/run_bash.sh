srun --cpus-per-task=8 --mem=8GB --time=4:00:00 --pty /bin/bash
source /scratch/work/courses/CHEM-GA-2671-2023fa/software/lammps-gcc-30Oct2022/setup_lammps.bash

cd Inputs
cp kalj.lmp ../Data/kalj.lmp
cp kalj_particles.lmp ../Data/kalj_particles.lmp

