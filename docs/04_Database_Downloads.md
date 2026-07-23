# Database Downloads

---

# 1. Introduction

Accurate variant annotation depends on high-quality reference databases. Each database integrated into this pipeline provides a different layer of biological or clinical information. Together, they enable comprehensive annotation, filtering, prioritization, and interpretation of genetic variants identified in Variant Call Format (VCF) files.

This document describes the databases used by the Generalized Rare Disease Variant Annotation Pipeline, their purpose, where they can be obtained, and how they are prepared for use.

---

# 2. Ensembl VEP Cache

## Purpose

The Ensembl Variant Effect Predictor (VEP) cache contains precomputed transcript and gene annotation data. Using the local cache significantly improves annotation speed and allows analyses to be performed without an internet connection.

## Information Provided

- Gene names
- Transcript IDs
- Protein consequences
- Coding changes
- Regulatory annotations
- Sequence ontology terms

## Download

The cache can be downloaded using the VEP installer:

```bash
perl INSTALL.pl
```

Select:

- Homo sapiens
- GRCh38
- Cache

## Verification

Confirm that the cache directory exists:

```bash
ls ~/.vep
```

---

# 3. ClinVar

## Purpose

ClinVar is maintained by the National Center for Biotechnology Information (NCBI) and provides expert-curated clinical interpretations of genetic variants.

## Information Provided

- Clinical significance
- Review status
- Associated diseases
- Variation IDs
- Supporting submissions

## Typical Clinical Significance Categories

- Pathogenic
- Likely Pathogenic
- Variant of Uncertain Significance (VUS)
- Likely Benign
- Benign

## File Format

Compressed VCF

```
clinvar.vcf.gz
```

The file should be indexed using:

```bash
tabix -p vcf clinvar.vcf.gz
```

---

# 4. gnomAD

## Purpose

The Genome Aggregation Database (gnomAD) provides allele frequencies from large human populations. Population frequency is essential for distinguishing common benign variants from rare candidate disease variants.

## Information Provided

- Global allele frequency
- Population-specific frequencies
- Homozygous counts
- Quality metrics

Variants with high population frequencies are less likely to be responsible for rare Mendelian disorders.

---

# 5. REVEL

## Purpose

REVEL (Rare Exome Variant Ensemble Learner) predicts the pathogenicity of missense variants using an ensemble machine learning approach.

## Information Provided

- REVEL score
- Pathogenicity prediction

### Score Interpretation

| Score | Interpretation |
|--------|----------------|
| <0.5 | Likely benign |
| 0.5–0.75 | Intermediate evidence |
| >0.75 | Strong evidence for pathogenicity |

The REVEL dataset should be compressed using `bgzip` and indexed using `tabix`.

---

# 6. AlphaMissense

## Purpose

AlphaMissense is a deep learning model developed by Google DeepMind for predicting the pathogenicity of missense variants.

## Information Provided

- Pathogenicity probability
- Classification
- Confidence score

AlphaMissense provides an additional computational assessment that complements traditional pathogenicity prediction tools.

---

# 7. ANNOVAR Databases

## Purpose

ANNOVAR supports annotation using multiple independent databases. Only the databases relevant to the project need to be downloaded.

Common databases include:

- RefGene
- ClinVar
- dbNSFP
- gnomAD
- Cytoband

These annotations are integrated into the final annotation output.

---

# 8. Database Preparation

Before use, ensure that downloaded files are:

- Complete
- Correctly compressed using `bgzip` (where required)
- Indexed using `tabix` (for VCF and TSV files)
- Stored in the appropriate database directory
- Compatible with the GRCh38 reference genome

Maintaining consistent reference genome versions across all databases is essential to avoid annotation errors.

---

# 9. Recommended Directory Structure

```
databases/
│
├── alphamissense/
├── annovar/
├── clinvar/
├── gnomad/
├── revel/
└── vep_cache/
```

This structure keeps annotation resources organised and simplifies pipeline configuration.

---

# 10. Database Maintenance

Public annotation databases are updated regularly. It is recommended to periodically download the latest releases and document the version used for each analysis to ensure reproducibility.

Whenever a database is updated, verify compatibility with the reference genome and annotation tools before replacing older versions.

---

# 11. Summary

The Generalized Rare Disease Variant Annotation Pipeline integrates multiple complementary databases to provide functional, population, and clinical annotations for genetic variants.

Using multiple annotation sources improves confidence in variant interpretation and supports more accurate downstream classification according to current clinical guidelines.
