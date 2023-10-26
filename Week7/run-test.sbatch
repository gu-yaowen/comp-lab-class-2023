#!/bin/bash -e

#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=10
#SBATCH --gres=gpu
#SBATCH --time=12:00:00
#SBATCH --mem=90GB
#SBATCH --job-name=alphaFold

/scratch/work/public/apps/alphafold/2.2.0/run-alphafold-2.2.0.py \
  --fasta_paths=Inputs/6d1r.fasta \
  --max_template_date=2020-05-14 \
  --output_dir=Inputs
