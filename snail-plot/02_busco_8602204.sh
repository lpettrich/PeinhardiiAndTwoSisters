#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=100GB
#SBATCH --time=25:00:00
#SBATCH --account=ag-waldvogel
#SBATCH --job-name=busco8602204
#SBATCH --error /scratch/lpettric/jobs/%x-%N-%j.err
#SBATCH --output /scratch/lpettric/jobs/%x-%N-%j.out
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=lpettric@smail.uni-koeln.de

module purge
module load bio/BUSCO/5.8.2-foss-2022b

OUTDIR=/home/lpettric/genomes/8602204/
mkdir -p $OUTDIR/busco




cd $OUTDIR/busco

busco -i $OUTDIR/8602204.draft.softmasked.fasta \
      -l nematoda_odb12 \
      -f \
      -o busco_nematoda \
      -m genome \
      -c 32 \
      --offline \
      --download_path /scratch/lpettric/busco/busco_downloads


busco -i $OUTDIR/8602204.draft.softmasked.fasta \
      -l metazoa_odb12 \
      -f \
      -o busco_metazoa \
      -m genome \
      -c 32 \
      --offline \
      --download_path /scratch/lpettric/busco/busco_downloads


busco -i $OUTDIR/8602204.draft.softmasked.fasta \
      -l eukaryota_odb12 \
      -f \
      -o busco_eukaryota \
      -m genome \
      -c 32 \
      --offline \
      --download_path /scratch/lpettric/busco/busco_downloads