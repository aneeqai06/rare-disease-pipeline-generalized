# Configuration & Sample Sheet Directory

This directory contains configuration templates and sample metadata sheets required to run the pipeline.

##  File Descriptions

* **`annotation_resources.env.example`**: Template configuration file defining paths to reference genomes, annotation databases, tool executables, and filtering thresholds.
  * *Usage:* Copy this file to `config/annotation_resources.env` and update paths according to your local system setup.
* **`sample_sheet.tsv`**: Master tab-separated sample manifest. Controls which samples, VCF files, target BED regions, and gene symbols are processed.

## Sample Sheet TSV Specifications

| Column Name | Description | Example |
| :--- | :--- | :--- |
| `sample_id` | Unique identifier for the sample | `sample_01` |
| `phenotype_id` | Phenotype or condition label | `condition_A` |
| `target_gene` | Target gene symbol for automated QC verification | `GENE_A` |
| `vcf_path` | Relative path to input VCF (`.vcf` or `.vcf.gz`) | `input/sample_01.vcf` |
| `bed_path` | Relative path to target region BED file | `input/sample_01_target.bed` |
EOF
