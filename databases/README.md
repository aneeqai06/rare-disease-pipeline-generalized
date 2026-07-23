
#  Annotation Databases & References Directory

This directory stores reference genomes, variant caches, pathogenicity predictor scores, and database indexes.

>  **Note:** Files in this directory (except `.gitkeep` and this `README.md`) are excluded from Git tracking via `.gitignore` due to file size constraints.

##  Required Database Directory Layout

```text
databases/
├── grch38.fa                          # Primary Reference Genome (GRCh38)
├── grch38.fa.fai                      # Reference FASTA index
├── clinvar.vcf.gz                     # ClinVar database VCF
├── vep/                               # Ensembl VEP offline cache
├── alphamissense/                     # AlphaMissense predictions (AlphaMissense_hg38.tsv.gz)
├── revel/                             # REVEL predictions (new_tabbed_revel_grch38.tsv.gz)
├── spliceai/                          # SpliceAI lookup VCF
└── snpeff/                            # SnpEff database JAR and configs
