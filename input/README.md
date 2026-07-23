```bash
cat << 'EOF' > input/README.md
# Input Data Directory

Place all raw patient VCFs and target region BED files here before starting an analysis run.

> **Note:** Raw VCF and BED files are excluded from Git commits via `.gitignore` to preserve data privacy.

## Expected Input Specifications

1. **VCF Files (`.vcf` or `.vcf.gz`)**: Standard genomic variant call files containing SNVs and indels.
2. **BED Files (`.bed`)**: 3-column or 4-column tab-separated files defining target capture or gene intervals.

##  Quick Example

```bash
# Copy your files into the input directory
cp /path/to/my_data.vcf input/sample_01.vcf
cp /path/to/my_panel.bed input/sample_01_target.bed
