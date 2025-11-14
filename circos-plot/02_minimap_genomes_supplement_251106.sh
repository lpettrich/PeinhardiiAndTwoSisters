#!/bin/bash -l
#SBATCH --nodes=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=100GB
#SBATCH --time=25:00:00
#SBATCH --account=ag-waldvogel
#SBATCH --job-name=pmapthreegenomes
#SBATCH --error /scratch/lpettric/jobs/%x-%N-%j.err
#SBATCH --output /scratch/lpettric/jobs/%x-%N-%j.out
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=lpettric@smail.uni-koeln.de

module purge
module load bio/minimap2/2.28-GCCcore-13.2.0


OUTDIR=/projects/ag-waldvogel/CRC1211/PanasGenomeReport/05_assembly-stats/06_circos_supplement_251106

ASM1=/projects/ag-waldvogel/CRC1211/PanasGenomeReport/10_final-assemblies/8602204/8602204.draft.softmasked.fasta
ASM2=/projects/ag-waldvogel/CRC1211/PanasGenomeReport/10_final-assemblies/PAP2229/pap2229.draft.softmasked.fasta
ASM3=/home/lpettric/genomes/ES5/es5.curated.fasta

PAF=$OUTDIR/8602204_PAP2229_ES5_minimap2_asm10.paf


cd $OUTDIR

# rename contigs
# For 8602204
awk '
/^>/ {
  name = substr($0, 2)
  if (name ~ /^scaffold_/) {
    gsub(/^scaffold_/, "scf", name)
    print ">8602204_" name
  } else {
    print ">" name
  }
  next
}
{ print }
' $ASM1 > 8602204.renamed.fasta


# For PAP2229
awk '
/^>/ {
  name = substr($0, 2)
  if (name ~ /^scaffold_/) {
    gsub(/^scaffold_/, "scf", name)
    print ">pap2229_" name
  } else {
    print ">" name
  }
  next
}
{ print }
' $ASM2 > pap2229.renamed.fasta


# For ES5
awk '
/^>/ {
  name = substr($0, 2)
  if (name ~ /^scaffold[0-9_]*$/) {
    gsub(/^scaffold/, "scf", name)
    print ">ES5_" name
  } else {
    print ">" name
  }
  next
}
{ print }
' $ASM3 > ES5.renamed.fasta


ASM1=8602204.renamed.fasta
ASM2=pap2229.renamed.fasta
ASM3=ES5.renamed.fasta


# run mapping

PAF=$OUTDIR/8602204_PAP2229_ES5_minimap2_asm10.paf
minimap2 -x asm10 $ASM1 $ASM2 $ASM3 > $PAF

PAF=$OUTDIR/8602204_PAP2229_minimap2_asm10.paf
minimap2 -x asm10 $ASM1 $ASM2 > $PAF

PAF=$OUTDIR/8602204_ES5_minimap2_asm10.paf
minimap2 -x asm10 $ASM1 $ASM3 > $PAF

PAF=$OUTDIR/PAP2229_ES5_minimap2_asm10.paf
minimap2 -x asm10 $ASM2 $ASM3 > $PAF


