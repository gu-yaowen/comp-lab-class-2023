source /scratch/work/courses/CHEM-GA-2671-2023fa/software/gromacs-2019.6-plumedSept2020/bin/GMXRC.bash.modules

gmx_mpi mdrun -v -s Inputs/dialaA/topolA.tpr -nsteps 10000000 -deffnm Inputs/dialaA/md_A

gmx_mpi mdrun -v -s Inputs/dialaB/topolB.tpr -nsteps 10000000 -deffnm Inputs/dialaB/md_B

cd Inputs/dialaA
plumed driver --plumed plumed_A.dat --mf_xtc md_A.xtc

cd ../dialaB
plumed driver --plumed plumed_B.dat --mf_xtc md_B.xtc
cd ../..

# run phi metadynamics for structure A
cd Inputs/dialaA
gmx_mpi mdrun -v -s topolA.tpr -nsteps 5000000 -plumed plumed_metad_phi_A.dat

# run psi metadynamics for structure A
gmx_mpi mdrun -v -s topolA.tpr -nsteps 5000000 -plumed plumed_metad_psi_A.dat
cd ../..

plumed sum_hills --hills HILLS --outfile metad_hill_A_all.dat

plumed sum_hills --hills HILLS --stride 100 --mintozero --outfile metad_hill_A.dat

for sigma in 0.2 0.35 0.7
do
    gmx_mpi mdrun -v -s topolA.tpr -nsteps 5000000 -plumed plumed_metad_phi_A_sigma$sigma.dat
    plumed sum_hills --hills HILLS_sigma$sigma --outfile metad_hill_A_all_sigma$sigma.dat
done

for height in 1.0 1.5
do
    gmx_mpi mdrun -v -s topolA.tpr -nsteps 5000000 -plumed plumed_metad_phi_A_height$height.dat
    plumed sum_hills --hills HILLS_height$height --outfile metad_hill_A_all_height$height.dat
done

for biasf in 1 2 5 15
do
    gmx_mpi mdrun -v -s topolA.tpr -nsteps 5000000 -plumed plumed_metad_phi_A_biasf$biasf.dat
    plumed sum_hills --hills HILLS_bf$biasf --outfile metad_hill_A_all_biasf$biasf.dat
done


gmx_mpi mdrun -v -s topolA.tpr -nsteps 5000000 -plumed plumed_metad_2D_A.dat
plumed sum_hills --hills HILLS_2D --outfile metad_hill_A_all_2D.dat
plumed sum_hills --hills HILLS_2D --stride 100 --mintozero --outfile metad_hill_2D.dat
