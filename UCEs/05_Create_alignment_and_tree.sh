#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=50GB
#SBATCH --time=150:00:00
#SBATCH --account=ag-waldvogel
#SBATCH --job-name=UCE-tree
#SBATCH --error /scratch/lpettric/jobs/%x-%N-%j.err
#SBATCH --output /scratch/lpettric/jobs/%x-%N-%j.out
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=lpettric@smail.uni-koeln.de


module load lang/Miniconda3/23.9.0-0
# conda activate phyluce_env # use newer version
conda activate phyluce-1.7.3 # or phyluce-1.7.3-x86 if using M-series CPU

cd /projects/ag-waldvogel/CRC1211/PanasGenomeReport/07-UCE-tree/taxon-sets/all/

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
# IMPORTANT: MERGE FASTA FROM GENOMES AND BAITS FOR ALIGNMENT

# tree with baits -> skip this step for now
#> all-taxa-incomplete_merged.fasta
#cat all-taxa-incomplete.fasta /scratch/lpettric/baits/all-taxa-incomplete.fasta > all-taxa-incomplete_merged.fasta

#taxa_count=$(grep -c "^>" all-taxa-incomplete_merged.fasta)

# TREE WITH ONLY HARVESTED GENOMES
taxa_count=27

mkdir -p log


# Step11: Aligment of UCE for species
phyluce_align_seqcap_align \
    --input  all-taxa-incomplete.fasta \
    --output mafft-nexus \
    --output-format nexus \
    --taxa $taxa_count \
    --aligner mafft \
    --cores 20 \
    --incomplete-matrix \
    --no-trim
    --log-path log
    
# do triming afterwards since all uce have been dropped with edge-trimming
phyluce_align_get_trimal_trimmed_alignments_from_untrimmed \
	--alignments mafft-nexus \
	--output mafft-nexus-trimmed \
	--input-format nexus \
	--output-format nexus
    
# Get summary of alignment
phyluce_align_get_align_summary_data \
    --alignments mafft-nexus-trimmed \
    --cores 12 \
    --log-path log

# Step12: Clean alignments
phyluce_align_remove_locus_name_from_files \
    --alignments mafft-nexus-trimmed \
    --output mafft-nexus-trimmed-clean \
    --cores 40 \
    --log-path log

# Step13: Create data matrix to create tree
phyluce_align_get_only_loci_with_min_taxa \
    --alignments mafft-nexus-trimmed-clean \
    --taxa $taxa_count \
    --percent 0.75 \
    --output mafft-nexus-trimmed-clean-75p \
    --cores 40 \
    --log-path log
    
# Step14: Concatenate alignment
phyluce_align_concatenate_alignments    \
    --alignments mafft-nexus-trimmed-clean-75p \
    --output mafft-nexus-trimmed-clean-75p-raxml    \
    --nexus 


# Step15: Get tree
module load bio/IQ-TREE/2.2.2.7-gompi-2023a

cd mafft-nexus-trimmed-clean-75p-raxml
iqtree2 -s mafft-nexus-trimmed-clean-75p-raxml.nexus -m MFP -bb 1000 -T 40

