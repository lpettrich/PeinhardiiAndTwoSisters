Set up conda environment
```console
module load lang/Miniconda3/23.9.0-0

conda create -n phyluce_env phyluce

conda activate phyluce_env

cat directories.txt | xargs mkdir
```


# Download data from ENA
Example P. detriophagus
```console
wget https://www.ebi.ac.uk/ena/browser/api/fasta/GCA_964187885.1
```
# Create 2bit files
```console
faToTwoBit ../../06_final-decontaminated-assembly/PAP2229/PAP2229_nextden_polish_decon_purged_scaffold_polish_final_renamed.fasta Panagrolaimus-PAP2229.2bit
```

```console
twoBitInfo Panagrolaimus-PAP2229.2bit sizes.tab
```

# Alternative: loop code block
```console
find . -type f \( -name "*.fna" -o -name "*.fasta" \) | while read file; do
  dir=$(dirname "$file")
  cd "$dir" || continue
```

## Get the first matching fasta/fna file in this directory
```console
  fasta=$(find . -maxdepth 1 -type f \( -name "*.fna" -o -name "*.fasta" \) | head -n 1)

  if [[ -n "$fasta" ]]; then
    dir_name=$(basename "$dir")
    faToTwoBit "$fasta" "${dir_name}.2bit"
    twoBitInfo "${dir_name}.2bit" sizes.tab
    rm -f "$fasta"
  fi

  cd - > /dev/null
done

```

