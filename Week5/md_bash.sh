module load gromacs/openmpi/intel/2018.3

# Production MD

gmx_mpi grompp -f Inputs/adp_T300.mdp -c Inputs/adp.gro -p Inputs/adp.top -o Inputs/adp_md.tpr

gmx_mpi mdrun -v -deffnm Inputs/adp_md

# #gmx_mpi mdrun -deffnm Data/1aki_md_0_1 -nb gpu

# # Analysis

# (echo "1"; echo "1") | gmx_mpi trjconv -s Data/1aki_md_0_1.tpr -f Data/1aki_md_0_1.xtc -o Data/1aki_md_0_1_noWater.xtc -pbc mol -center

# (echo "1"; echo "1") | gmx_mpi trjconv -s Data/1aki_md_0_1.tpr -f Data/1aki_md_0_1.gro -o Data/1aki_md_0_1_noWater.gro -pbc mol -center



# (echo "4"; echo "4") | gmx_mpi rms -s Data/1aki_md_0_1.tpr -f Data/1aki_md_0_1_noWater.xtc -o Analysis/1aki_rmsd.xvg -tu ns

# (echo "4"; echo "4") | gmx_mpi rms -s Data/1aki_em.tpr -f Data/1aki_md_0_1_noWater.xtc -o Analysis/1aki_rmsd_xtal.xvg -tu ns

# echo "1" | gmx_mpi gyrate -s Data/1aki_md_0_1.tpr -f Data/1aki_md_0_1_noWater.xtc -o Analysis/1aki_gyrate.xvg