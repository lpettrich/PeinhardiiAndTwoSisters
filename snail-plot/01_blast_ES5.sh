#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=100GB
#SBATCH --time=25:00:00
#SBATCH --account=ag-waldvogel
#SBATCH --job-name=blastES5
#SBATCH --error /scratch/lpettric/jobs/%x-%N-%j.err
#SBATCH --output /scratch/lpettric/jobs/%x-%N-%j.out
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=lpettric@smail.uni-koeln.de

module purge
module load bio/SAMtools/1.19.2-GCC-13.2.0
module load bio/BCFtools/1.19-GCC-13.2.0
module load bio/minimap2/2.28-GCCcore-13.2.0
module load lang/Miniconda3/23.9.0-0

OUTDIR=/home/lpettric/genomes/ES5

samtools faidx $OUTDIR/es5.curated.fasta

conda activate blast_env

blastn -db /scratch/lpettric/nt/nt \
       -query $OUTDIR/es5.curated.fasta \
       -outfmt "6 qseqid staxids bitscore std" \
       -max_target_seqs 10 \
       -max_hsps 1 \
       -evalue 1e-25 \
       -num_threads 32 \
       -out /scratch/lpettric/blobtools/es5.curated.fasta_genome_20250722.ncbi.blastn.run.out
       
       
mkdir -p $OUTDIR/blast
cp /scratch/lpettric/blobtools/es5.curated.fasta_genome_20250722.ncbi.blastn.run.out $OUTDIR/blast
