#!/bin/bash -e

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=1
#SBATCH --time=4:00:00
#SBATCH --mem=8GB
#SBATCH --job-name=Week9

mpirun lmp -var configfile ../Inputs/n360/kalj_n360_create.lmp -var id 1 -in ../Inputs/create_3d_binary.lmp

for t in 1.5 1.0 0.9 0.8 0.7 0.65 0.6 0.55 0.5 0.475 0.45; do
    mpirun lmp -var configfile ../Inputs/n360/kalj_n360_T$t.lmp -var id 1 -in ../Inputs/anneal_3d_binary.lmp
done
