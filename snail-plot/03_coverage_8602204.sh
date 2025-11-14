#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=100GB
#SBATCH --time=25:00:00
#SBATCH --account=ag-waldvogel
#SBATCH --job-name=coverage8602204
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

READS=/projects/ag-waldvogel/CRC1211/PanasGenomeReport/01_basecalled-reads/8602204/8602204_duplex.dorado_v1.0.1_sup.q20.fastq.gz
ASM=/projects/ag-waldvogel/CRC1211/PanasGenomeReport/10_final-assemblies/8602204/8602204.draft.softmasked.fasta
OUTDIR=/projects/ag-waldvogel/CRC1211/PanasGenomeReport/10_final-assemblies/8602204
mkdir -p /projects/ag-waldvogel/CRC1211/PanasGenomeReport/10_final-assemblies/8602204/coverage

minimap2 -ax map-ont \
         -t 32 $ASM \
         $READS \
| samtools sort -@32 -O BAM -o $OUTDIR/coverage/8602204.draft.softmasked.q20.bam -
