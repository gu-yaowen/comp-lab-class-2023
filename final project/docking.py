import sys
from vina import Vina
import os
import numpy as np
import pandas as pd

if __name__ == '__main__':

    pdb = 'data/7ugw.pdbqt'
    center = [0.816, 0.108, -0.189]
    drug = 'data/quarfloxin.pdbqt'

    v = Vina(sf_name='vina')
    v.set_receptor(pdb)
    box = 20
    v.compute_vina_maps(center=center, box_size=[box, box, box])

    results = {}
    v.set_ligand_from_file(drug)
    v.dock(exhaustiveness=32, n_poses=10)
    energy_minimized = v.optimize()
    print('Score after minimization : %.3f (kcal/mol)' % energy_minimized[0])
    results[cid] = energy_minimized[0]
    v.write_poses(f'{cid}_vina_out.pdbqt',
                  n_poses=10, overwrite=True)
