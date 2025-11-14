#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=25
#SBATCH --mem=100GB
#SBATCH --time=20:00:00
#SBATCH --account=ag-waldvogel
#SBATCH --job-name=UCE
#SBATCH --error /scratch/lpettric/jobs/%x-%N-%j.err
#SBATCH --output /scratch/lpettric/jobs/%x-%N-%j.out
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=lpettric@smail.uni-koeln.de


module load lang/Miniconda3/23.9.0-0
conda activate phyluce_env

cd /projects/ag-waldvogel/CRC1211/PanasGenomeReport/07-UCE-tree

# Step1: Create directory
# Step2: Download data and gunzip
# Step3: Create 2bit files
# Step4: Download probe set from UCE paper


# Step5: Align the probes to the genomes
# run the search
phyluce_probe_run_multiple_lastzs_sqlite \
    --db panagrolaimus.sqlite \
    --output panagrolaimus-genome-lastz \
    --scaffoldlist Acrobeloidesmaximus Acrobeloidesobliquus Acrobeloidesthornei AcrobeloidestricornisPAP2217 HalicephalobusNKZ332 Halicephalobusmephisto Panagrellusredivivus Panagrolaimus8602204 PanagrolaimusALT2208 PanagrolaimusES5 PanagrolaimusJU1366 PanagrolaimusJU1367 PanagrolaimusJU1371 PanagrolaimusJU1387 PanagrolaimusJU1645 PanagrolaimusLJ2400 PanagrolaimusLJ2406 PanagrolaimusLJ2414 PanagrolaimusPAP2229 PanagrolaimusPS1159 PanagrolaimusPS1579 Panagrolaimusdavidi Panagrolaimusdetritophagus Panagrolaimuskolymaensis Panagrolaimussuperbus PropanagrolaimusJU765 PropanagrolaimusLC92 \
    --genome-base-path ./ \
    --probefile Panagrolaimus1-v1-master-probe-list-DUPE-SCREENED.fasta \
    --identity 50 \
    --cores 25
