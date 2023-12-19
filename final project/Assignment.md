# Fianl project: Molecular docking for the discovery of anti-mycobacterium tuberculosis candidates targeting DNA gyrase protein

## Prepare protein
1. Download protein structure data (PDB ID: 7ugw) from RCSB database (https://www.rcsb.org/)
	- Read the PDB file, and combine the 3D image from VMD or PyMOL, is there any structures except for protein in the file? Identify which part is the default ligand and delete it to make a clean protein structure file.

2. Use ADFRsuite to get protein prepared for molecular docking
	- Download the Linux version of ADFRsuite from https://ccsb.scripps.edu/adcp/downloads/. Untar the downloaded file with `tar zxvf ADFRsuite_x86_64Darwin_1.0.tar.gz`
	- Create a Python 2.7 environment to run ADFRsuite
	- Prepare protein PDB with `ADFRsuite/bin/prepare_receptor -r {TARGET}.pdb -o {TARGET}.pdbqt`
	- NOTE: the ADFRsuite exceeds the storage limit (~400MB) that I could not submit it to GitHub.

## Prepare ligand
1. There are two case ligands with the format of SMILES in `ligand.csv`, using RDkit to generate initial conformers for them.
	- Read molecule SMILES with `rdkit.Chem.MolFromSmiles`, add hydrogen, and use `rdkit.AllChem.EmbedMolecule` to generate trivial molecular 3D conformers.
	- Save the molecule to PDB file with `rdkit.AllChem.MolToPDBBlock` 
	- Bonus: what if we don't know the molecule SMILES structure? Try to get molecule SMILES from other identifiers (e.g., CAS number, PubChem ID).
	- Bonus: simply use EmbedMolecule maynot get a topologically reasonable conformer. Try use molecular force field (e.g., MMFF94) to further optimize them. A referred function is `rdkit.AllChem.MMFFOptimizeMolecule` and https://github.com/gu-yaowen/EquiVS/blob/main/conformer.py

2. Use ADFRsuite to get ligands prepared for molecular docking 
	- prepare ligand PDB with `ADFRsuite/bin/prepare_ligand -l {LIGAND}.pdb -o {LIGAND}.pdbqt`

## Molecular docking
1. Download/load Autodock Vina
	- For a python environment by referring https://autodock-vina.readthedocs.io/en/latest/installation.html
2. Setup parameters
	- The docking box is curcial to get rational docking poses. There are two ways to determine the coordinates of docing box grid center: 1. the previous reported center or the center of default ligand in RCSB database; 2. generate the grid parameter file by Autodock Vina which contains the suggested grid center; 3. some external protein pocket prediction tools (e.g, https://proteins.plus/).
	- For the second method, copy the `prepare_ligand4.py` from https://github.com/ccsb-scripps/AutoDock-Vina/tree/develop/example/autodock_scripts to your folder. Then, run `pythonsh prepare_gpf.py -r 7ugw.pdbqt -l quarfloxin.pdbqt -y`, and capture the coordinate after `gridcenter` line manually or automatically by simple code functions.
	- Other parameters: 1. box_size (default setting: [20, 20, 20]): the conformation search space. Generally, a larger box_size may get slightly better docking results but cause heavy running time; 2. exhaustiveness (default setting: 32): the granularity of docking which significantly influences the docking running time; 3. n_poses (default setting: 10): the number of output ligand poses.

3. Start docking
	- Organize codes to execute the docking for protein and the ligand in `ligand.csv` with their PDBQT files. The basic python script can be referred from https://github.com/ccsb-scripps/AutoDock-Vina/blob/develop/example/python_scripting/first_example.py.
	- Save generated docking poses to a PDBQT file for each file, and record the output log including the Vina score, RMSD l.b., and RMSD u.b. to a CSV file as the docking results.
	- Bonus: it is labor-consuming to dock ligands one-by-one. Can the above processes (prepare protein, prepare ligands, docking) can be integrated as an automatic procedure? For example, use `os.system` to run terminal commands may be helpful for integration.

## Analysis
1. Data transformation
	- Use openbable to transfer PDBQT file to PDB format. A more simple way is to manually modify the format as PDBQT and PDB are much similar.
	- Insert the atom position in ligand file to protein file to create the complex PDB file `{TARGET}_{LIGAND}.pdb`.
2. Protein-ligand binding profile visualization on VMD
	- Look at the complex structure on VMD, is the docking pose reasonable? Save a screenshot of the complex structure.
3. 2D molecule interaction modes visualization on LigPLot+
	- Download LigPlot+ from https://www.ebi.ac.uk/thornton-srv/software/LigPlus/download2.html (Someone may need to download Java SE Runtime Environment (JRE) first).
	- Following the documentation (https://www.ebi.ac.uk/thornton-srv/software/LigPlus/manual2/manual.html), run `LigPlus.jar` and load the complex PDB file. Then, select the identifier of ligand in `LIGPLOT` for plotting.
	- The output figure shows the 2D interaction of protein residue atom and ligand atoms. Is there any hydrogen bonds formed between protein and ligand atoms? Adjust the position and rename the protein and ligand. Save a screenshot of the figure.
4. Fine-grained 3D binding poses visualization on PyMol
	- Download PyMol from https://pymol.org/2/. Use NYU account to get usage permission for education version.
	- Now open LigPLot+ again, in `Edit->Program Paths`, link the downloaded PyMol folder address to LigPlot+.
	- In LigPlot+, after loading the structure and getting the visualization results, click the `PyMol` and it will automatically switch to PyMol software. The shown structure is the 3D local binding poses for protein-ligand pair. Protein surfaces, binded residues, and hydrogen formation will be shown. Rotate the structure in a desirable manner, change the background to white, and finally save the figure. 