# Output Interpretation

---

# 1. Introduction

The Generalized Rare Disease Variant Annotation Pipeline produces multiple output files during the annotation process. Each file provides different information about the analyzed variants, ranging from quality control reports to functional annotations and clinical classifications.

Understanding these outputs is essential for identifying potentially disease-causing variants and making informed decisions during downstream analysis. This document describes the purpose of each output file, the information it contains, and how the results should be interpreted.

---

# 2. Output Directory Structure

A typical output directory is organized as follows:

```
output/
├── qc/
├── normalized/
├── vep/
├── snpeff/
├── annovar/
├── intervar/
├── logs/
└── final/
```

Each folder corresponds to a specific stage of the annotation pipeline.

---

# 3. Quality Control Outputs

The `qc/` directory contains reports generated during the initial validation of the input Variant Call Format (VCF) file.

These reports help identify problems before annotation begins.

Typical checks include:

- VCF format validation
- Header verification
- Reference allele consistency
- Duplicate variants
- Chromosome naming conventions

A successful quality control stage should report no critical errors.

---

# 4. Normalized Variants

The `normalized/` directory contains the VCF after preprocessing with `bcftools`.

Normalization ensures that variants follow a consistent representation.

Typical operations include:

- Left alignment
- Indel normalization
- Splitting multiallelic variants
- Reference validation

Users should verify that the number of variants matches expectations and that no unexpected records have been introduced or removed.

---

# 5. VEP Annotation Output

The VEP output provides the primary functional annotation for each variant.

Common annotation fields include:

- Gene symbol
- Transcript ID
- HGVS nomenclature
- Protein change
- Variant consequence
- Sequence Ontology term

Example:

```
Gene: TP53
Consequence: missense_variant
Protein: p.Arg248Gln
HGVS: c.743G>A
```

These annotations describe the predicted biological effect of the variant.

---

# 6. SnpEff Annotation Output

SnpEff provides an independent prediction of variant effects.

Typical annotations include:

- HIGH impact
- MODERATE impact
- LOW impact
- MODIFIER impact

Examples:

- Missense variant
- Nonsense variant
- Frameshift variant
- Synonymous variant
- Splice region variant

Agreement between VEP and SnpEff generally increases confidence in the annotation.

---

# 7. ClinVar Annotation

ClinVar provides clinically curated interpretations.

Common clinical significance values include:

| Classification | Interpretation |
|----------------|----------------|
| Pathogenic | Strong evidence for disease association |
| Likely Pathogenic | Likely disease-causing |
| VUS | Insufficient evidence |
| Likely Benign | Unlikely to cause disease |
| Benign | No known clinical significance |

Users should also consider the ClinVar review status when interpreting classifications.

---

# 8. gnomAD Population Frequencies

The gnomAD database provides allele frequencies observed in large human populations.

Interpretation guidelines:

- Very rare variants are stronger candidates for rare diseases.
- Common variants are generally less likely to be responsible for highly penetrant Mendelian disorders.

Population frequency should always be interpreted alongside other evidence.

---

# 9. REVEL Scores

REVEL predicts the pathogenicity of missense variants.

General interpretation:

| REVEL Score | Interpretation |
|--------------|---------------|
| <0.50 | Likely benign |
| 0.50–0.75 | Intermediate evidence |
| >0.75 | Strong evidence supporting pathogenicity |

REVEL is intended to support, not replace, expert interpretation.

---

# 10. AlphaMissense Predictions

AlphaMissense applies deep learning to estimate the pathogenic potential of missense variants.

The output may include:

- Prediction score
- Classification
- Confidence level

Higher scores generally indicate stronger evidence that a missense variant may affect protein function.

---

# 11. ANNOVAR Output

ANNOVAR generates tabular annotations by integrating multiple databases.

Typical columns include:

- Gene name
- Functional annotation
- Exonic function
- Population frequency
- Clinical databases
- Additional prediction scores

The table provides a convenient format for downstream filtering and prioritization.

---

# 12. InterVar ACMG Classification

InterVar applies the ACMG/AMP guidelines to classify variants.

Possible outcomes include:

- Pathogenic
- Likely Pathogenic
- Variant of Uncertain Significance (VUS)
- Likely Benign
- Benign

InterVar also reports the ACMG evidence codes used to support each classification.

These classifications should be interpreted in conjunction with all available clinical and experimental evidence.

---

# 13. Log Files

The `logs/` directory records the execution of each pipeline stage.

Log files should be reviewed whenever:

- A command fails.
- Output files are incomplete.
- Unexpected warnings appear.

Logs are essential for debugging and reproducibility.

---

# 14. Final Annotated Dataset

The final output integrates annotations from all stages of the pipeline into a comprehensive dataset.

This dataset may include:

- Functional consequences
- Clinical significance
- Population frequencies
- Computational prediction scores
- ACMG classification

Researchers can use the final annotated dataset for variant prioritization, downstream filtering, and clinical interpretation.

---

# 15. Best Practices for Interpretation

When reviewing annotated variants:

- Consider multiple annotation sources rather than relying on a single database.
- Verify that all annotations use the same reference genome.
- Review variants in the context of the patient's phenotype.
- Record database versions and software versions used for annotation.
- Document any manual interpretation decisions.

Annotation provides evidence but does not replace expert clinical judgement.

---

# 16. Summary

The outputs generated by the Generalized Rare Disease Variant Annotation Pipeline provide complementary information describing the functional, population, and clinical characteristics of genetic variants.

Accurate interpretation requires integrating evidence from multiple annotation sources while maintaining reproducibility and careful documentation throughout the analysis.
