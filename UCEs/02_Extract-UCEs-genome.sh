#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=100GB
#SBATCH --time=50:00:00
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

# Step6: Create config file
> genomes.conf
echo "[scaffolds]" > genomes.conf && find . -name "*.2bit" | while read file; do dir=$(basename "$(dirname "$file")"); echo "${dir}:$(realpath "$file")"; done >> genomes.conf


# Step7: Extract UCEs from genome
phyluce_probe_slice_sequence_from_genomes     \
    --lastz panagrolaimus-genome-lastz  \
    --conf genomes.conf    \
    --flank 500     \
    --name-pattern "Panagrolaimus1-v1-master-probe-list-DUPE-SCREENED.fasta_v_{}.lastz.clean"   \
    --output panagrolaimus-genome-fasta 
    
    
# END OF HARVEST UCE FROM GENOMES
