#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=100GB
#SBATCH --time=25:00:00
#SBATCH --account=ag-waldvogel
#SBATCH --job-name=blast8602204
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

OUTDIR=/projects/ag-waldvogel/CRC1211/PanasGenomeReport/10_final-assemblies/8602204/

samtools faidx $OUTDIR/8602204.draft.softmasked.fasta

conda activate blast_env

blastn -db /scratch/lpettric/nt/nt \
       -query $OUTDIR/8602204.draft.softmasked.fasta \
       -outfmt "6 qseqid staxids bitscore std" \
       -max_target_seqs 10 \
       -max_hsps 1 \
       -evalue 1e-25 \
       -num_threads 32 \
       -out /scratch/lpettric/blobtools/8602204/8602204.draft.softmasked.ncbi.blastn.run.out
       
       
mkdir -p /projects/ag-waldvogel/CRC1211/PanasGenomeReport/10_final-assemblies/8602204/blast
cp /scratch/lpettric/blobtools/8602204/8602204.draft.softmasked.ncbi.blastn.run.out /projects/ag-waldvogel/CRC1211/PanasGenomeReport/06_final-decontaminated-assembly/8602204/blast
