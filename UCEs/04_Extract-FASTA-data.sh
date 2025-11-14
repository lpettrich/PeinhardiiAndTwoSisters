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
# Step7: Extract UCEs from genome
# Step8: Match UCEs to probes
# Step9. Extract UCE loci  
# IMPORTANT: WRITE DOWN NUMBER OF TAXA AND FILL IN FOR NEXT COMMANDS!

# Step10: Extract FASTA data that correspond to the loci in all-taxa-incomplete.conf
cd taxon-sets/all/
phyluce_assembly_get_fastas_from_match_counts \
    --contigs /projects/ag-waldvogel/CRC1211/PanasGenomeReport/07-UCE-tree/panagrolaimus-genome-fasta \
    --locus-db /projects/ag-waldvogel/CRC1211/PanasGenomeReport/07-UCE-tree/uce-search-results/probe.matches.sqlite \
    --match-count-output all-taxa-incomplete.conf \
    --output all-taxa-incomplete.fasta \
    --incomplete-matrix all-taxa-incomplete.incomplete