
#  Pipeline Results Directory

Generated analysis outputs and logs land here, organized into sample-specific subdirectories (`output/<sample_id>/`).

>  **Note:** Output files are ignored by Git.

##  Output Folder Layout Example

```text
output/sample_01/
├── sample_01.normalized.vcf           # Left-aligned and split multiallelic VCF
├── sample_01.ref_check.vcf             # Reference-verified & target-sliced VCF
├── sample_01.vep_annotated.vcf         # Ensembl VEP annotated VCF
├── sample_01.snpeff.vcf                # SnpEff impact annotated VCF
├── sample_01.annovar.hg38_multianno.txt# ANNOVAR multi-database table
├── sample_01.intervar.*                # InterVar ACMG classification files
├── qc_report.txt                       # Automated QC verification summary
└── logs/                               # Stage execution timestamped logs
