# Pipeline Workflow

---

# 1. Introduction

The Generalized Rare Disease Variant Annotation Pipeline is a modular bioinformatics workflow designed to transform raw Variant Call Format (VCF) files into biologically and clinically interpretable datasets. Rather than relying on a single annotation source, the pipeline integrates multiple open-source tools and public databases to provide comprehensive functional, population, and clinical annotations.

The workflow is organized into independent modules, allowing users to execute individual stages or the complete pipeline depending on their analysis requirements. This modular design improves reproducibility, simplifies troubleshooting, and enables future expansion.

---

# 2. Pipeline Overview

The overall workflow is illustrated below.

```
Input VCF
    │
    ▼
Quality Control
    │
    ▼
Reference Genome Validation
    │
    ▼
Variant Normalization
    │
    ▼
Functional Annotation (VEP)
    │
    ▼
Gene Effect Annotation (SnpEff)
    │
    ▼
Clinical Database Annotation
    ├── ClinVar
    ├── gnomAD
    ├── REVEL
    └── AlphaMissense
    │
    ▼
ANNOVAR Annotation
    │
    ▼
ACMG Classification (InterVar)
    │
    ▼
Final Annotated Output
```

Each stage produces output that serves as the input for the following stage.

---

# 3. Input Data

The pipeline accepts Variant Call Format (VCF) files aligned to the GRCh38 human reference genome.

Input files should:

- Follow the VCF specification.
- Contain valid chromosome names.
- Include reference and alternate alleles.
- Be compressed and indexed when appropriate.

The quality of downstream analyses depends on the quality of the input data.

---

# 4. Quality Control

Before annotation, the input VCF file is evaluated to identify formatting issues and inconsistencies.

Quality control includes:

- File format validation
- Header inspection
- Reference allele consistency
- Duplicate record detection
- Chromosome naming consistency

Early quality control prevents downstream annotation failures.

---

# 5. Variant Normalization

Variant normalization ensures that all variants are represented consistently.

This step includes:

- Left alignment
- Indel normalization
- Splitting multiallelic variants
- Reference allele validation

bcftools is used for these operations.

Normalizing variants improves compatibility with downstream annotation tools and public databases.

---

# 6. Functional Annotation Using VEP

The Ensembl Variant Effect Predictor (VEP) performs primary functional annotation.

Annotations include:

- Gene symbols
- Transcript IDs
- Coding consequences
- Protein consequences
- Sequence Ontology terms
- HGVS nomenclature

VEP forms the foundation of the annotation process.

---

# 7. Gene Effect Annotation Using SnpEff

SnpEff provides an independent assessment of variant effects.

Predicted annotations include:

- Synonymous variants
- Missense variants
- Nonsense variants
- Frameshift variants
- Splice region variants

Comparing SnpEff and VEP annotations provides additional confidence during interpretation.

---

# 8. Clinical Annotation

The pipeline enriches variants using multiple public databases.

## ClinVar

Provides:

- Clinical significance
- Disease associations
- Review status

---

## gnomAD

Provides:

- Population allele frequency
- Population-specific frequencies
- Homozygous counts

---

## REVEL

Provides:

- Missense pathogenicity score

---

## AlphaMissense

Provides:

- AI-based pathogenicity prediction
- Confidence scores

Together, these resources improve variant prioritization.

---

# 9. ANNOVAR Annotation

ANNOVAR performs additional annotation using selected databases.

Depending on the configured databases, ANNOVAR can provide:

- Gene-based annotations
- Region-based annotations
- Filter-based annotations

The output complements VEP and SnpEff results.

---

# 10. ACMG Classification

InterVar evaluates annotated variants using the ACMG/AMP guidelines.

Possible classifications include:

- Pathogenic
- Likely Pathogenic
- Variant of Uncertain Significance (VUS)
- Likely Benign
- Benign

The ACMG framework supports standardized clinical interpretation.

---

# 11. Pipeline Outputs

Typical outputs include:

- Normalized VCF
- VEP annotated VCF
- SnpEff annotated VCF
- ANNOVAR annotation tables
- InterVar classification report
- Log files
- Quality control reports

Each output contributes to the overall interpretation process.

---

# 12. Directory Organization

A recommended output structure is shown below.

```
output/
├── normalized/
├── vep/
├── snpeff/
├── annovar/
├── intervar/
├── qc/
└── logs/
```

Organizing results by analysis stage simplifies downstream review and troubleshooting.

---

# 13. Reproducibility

Reproducibility is a key objective of this project.

To support reproducible analyses:

- Record software versions.
- Record database versions.
- Use consistent reference genomes.
- Maintain project documentation.
- Preserve configuration files.
- Track changes using Git.

---

# 14. Future Improvements

The pipeline architecture has been designed to support future expansion.

Potential additions include:

- Structural variant annotation
- Copy number variant annotation
- Automated report generation
- Containerized deployment
- Workflow management systems
- Cloud execution

---

# 15. Summary

The Generalized Rare Disease Variant Annotation Pipeline combines established bioinformatics software with curated public databases to generate comprehensive annotations for human genetic variants.

Its modular architecture allows users to adapt the workflow to different projects while maintaining reproducibility, transparency, and compatibility with clinical variant interpretation standards.
