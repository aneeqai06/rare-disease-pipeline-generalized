# Laboratory Manual

---

# Generalized Rare Disease Variant Annotation Pipeline

Version 1.0

---

# Table of Contents

1. Introduction
2. Learning Objectives
3. Background
4. Preparing the Working Environment
5. Preparing Input Data
6. Running the Annotation Pipeline
7. Understanding Intermediate Outputs
8. Reviewing Final Results
9. Cleaning the Workspace
10. Best Practices
11. Frequently Asked Mistakes
12. Summary

---

# 1. Introduction

This laboratory manual provides a practical guide for performing variant annotation using the Generalized Rare Disease Variant Annotation Pipeline. It is intended for students, researchers, and laboratory personnel with a basic understanding of molecular biology and genetics.

Unlike the technical documentation, this manual focuses on the practical workflow that a user follows during routine analyses.

The exercises described in this manual assume that all required software and annotation databases have already been installed according to the Installation Guide.

---

# 2. Learning Objectives

After completing this laboratory exercise, users should be able to:

- Understand the purpose of variant annotation.
- Organize project files correctly.
- Prepare Variant Call Format (VCF) files for analysis.
- Perform quality control.
- Execute each annotation step.
- Interpret the generated outputs.
- Understand the role of each annotation database.
- Produce reproducible analyses.

---

# 3. Background

Next-generation sequencing experiments produce large numbers of genetic variants. These variants initially contain only genomic coordinates and allele information.

Variant annotation enriches these variants with biological and clinical information obtained from multiple public databases.

The pipeline combines several annotation tools to provide comprehensive information regarding:

- Gene function
- Protein consequences
- Population frequencies
- Clinical significance
- Computational pathogenicity predictions
- ACMG variant classification

---

# 4. Preparing the Working Environment

Before beginning the analysis, verify that:

- Ubuntu is functioning correctly.
- Conda environment is activated.
- Required databases are available.
- Reference genome files are present.
- Input VCF files are accessible.
- Required software is installed.

A recommended project structure is:

```

project/
│
├── input/
├── output/
├── databases/
├── logs/
└── scripts/

```

Maintaining an organized directory structure simplifies project management and improves reproducibility.

---

# 5. Preparing Input Data

The pipeline accepts Variant Call Format (VCF) files generated from variant calling software.

Before annotation, confirm that the input file:

- Uses the GRCh38 reference genome.
- Contains valid chromosome identifiers.
- Has a complete VCF header.
- Includes reference and alternate alleles.
- Passes basic format validation.

Poor-quality input files frequently cause downstream annotation errors.

---

# 6. Running the Annotation Pipeline

The annotation workflow follows these stages:

1. Quality Control
2. Variant Normalization
3. Functional Annotation (VEP)
4. Gene Effect Annotation (SnpEff)
5. Clinical Annotation
6. Population Frequency Annotation
7. ANNOVAR Annotation
8. ACMG Classification (InterVar)

Each stage produces intermediate files that are stored in the output directory.

Users are encouraged to inspect these files before continuing to the next step.

---

# 7. Understanding Intermediate Outputs

Several intermediate files are generated during analysis.

Typical outputs include:

- Normalized VCF
- VEP annotation output
- SnpEff annotation output
- ANNOVAR tables
- Quality control reports
- Log files

Intermediate outputs are useful for troubleshooting and verifying that each stage completed successfully.

---

# 8. Reviewing Final Results

The final annotated dataset combines information from multiple annotation resources.

Users should review:

- Gene annotations
- Variant consequences
- Clinical significance
- Population frequencies
- Computational prediction scores
- ACMG classifications

These annotations support downstream interpretation but should always be reviewed within the appropriate clinical or research context.

---

# 9. Cleaning the Workspace

After analysis:

- Remove unnecessary temporary files.
- Archive important outputs.
- Record software versions.
- Record database versions.
- Backup final results.

Maintaining a clean workspace improves reproducibility and simplifies future analyses.

---

# 10. Best Practices

The following practices are recommended:

- Always maintain the original input files.
- Never overwrite intermediate outputs.
- Document software versions.
- Record database release dates.
- Validate all downloaded databases.
- Use consistent reference genomes.
- Maintain project documentation using Git.

Following these recommendations helps ensure reproducible and transparent analyses.

---

# 11. Frequently Encountered Mistakes

Common issues include:

- Using incompatible reference genomes.
- Missing annotation databases.
- Incorrect chromosome naming.
- Corrupted compressed files.
- Missing index files.
- Incorrect software versions.
- Running analyses in the wrong Conda environment.

Understanding these issues can significantly reduce troubleshooting time.

---

# 12. Summary

This laboratory manual provides a practical workflow for performing rare disease variant annotation using the Generalized Rare Disease Variant Annotation Pipeline.

Following the procedures described in this guide will help users produce consistent, reproducible, and well-documented analyses suitable for research and educational applications.
