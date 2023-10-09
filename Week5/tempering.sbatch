#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=3
#SBATCH --cpus-per-task=1
#SBATCH --time=20:00:00
#SBATCH --mem=8GB
#SBATCH --job-name=Parallel_tempering 
#SBATCH --output=Parallel_tempering.out

module load gromacs/openmpi/intel/2018.3

# modify the mdp file in T300, T363, T440 folder to change the temperature
# parameter: ref_t = 300, 363, 440, gen_temp = 300, 363, 440
for t in 300 363 440
do
    gmx_mpi grompp -f Data/T${t}/adp.mdp -c Inputs/adp.gro -p Inputs/adp.top -o Data/T${t}/adp.tpr
done

# gmx_mpi grompp -f Data/T300/adp.mdp -c Inputs/adp.gro -p Inputs/adp.top -o Data/T300/adp.tpr
# gmx_mpi grompp -f Data/T363/adp.mdp -c Inputs/adp.gro -p Inputs/adp.top -o Data/T363/adp.tpr
# gmx_mpi grompp -f Data/T440/adp.mdp -c Inputs/adp.gro -p Inputs/adp.top -o Data/T440/adp.tpr

mpirun -np 3 gmx_mpi mdrun -s adp -multidir Data/T300/ Data/T363/ Data/T440/ -deffnm adp_exchange3temps -replex 50

# calculate the potential energy of each replica
for t in 300 363 440
do
    echo "10" | gmx_mpi energy -f Data/T${t}/adp_exchange3temps.edr -o Analysis/T${t}_potential_energy.xvg
done

# echo "10" | gmx_mpi energy -f Data/T300/adp_exchange3temps.edr -o Analysis/T300_potential_energy.xvg
# echo "10" | gmx_mpi energy -f Data/T363/adp_exchange3temps.edr -o Analysis/T363_potential_energy.xvg
# echo "10" | gmx_mpi energy -f Data/T440/adp_exchange3temps.edr -o Analysis/T440_potential_energy.xvg

# calculate the temperature of each replica
for t in 300 363 440
do
    cd Data/T${t}/
    demux.pl adp_exchange3temps.log
    mv replica_index.xvg ../../Analysis/T${t}_replica_index.xvg
    mv replica_temp.xvg ../../Analysis/T${t}_replica_temp.xvg
    cd ../../
done
