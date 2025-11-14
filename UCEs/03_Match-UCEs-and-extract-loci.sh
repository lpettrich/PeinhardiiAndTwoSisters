#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --mem=200GB
#SBATCH --time=150:00:00
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
phyluce_assembly_match_contigs_to_probes \
    --contigs panagrolaimus-genome-fasta  \
    --probes Panagrolaimus1-v1-master-probe-list-DUPE-SCREENED.fasta \
    --output uce-search-results &
wait

# Step9. Extract UCE loci
 { echo "[all]"; for file in uce-search-results/*.lastz; do basename "$file" .lastz; done; } > taxon-set.conf

 mkdir taxon-sets
 cd taxon-sets
 mkdir all
 cd ..

phyluce_assembly_get_match_counts \
    --locus-db uce-search-results/probe.matches.sqlite \
    --taxon-list-config taxon-set.conf \
    --taxon-group 'all' \
    --incomplete-matrix \
    --output taxon-sets/all/all-taxa-incomplete.conf 
    
# IMPORTANT: WRITE DOWN NUMBER OF TAXA AND FILL IN FOR NEXT COMMANDS!