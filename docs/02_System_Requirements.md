# System Requirements

## 1. Overview

This document describes the hardware, operating system, software, bioinformatics tools, annotation databases, and storage requirements needed to use the Generalized Rare Disease Variant Annotation Pipeline. The purpose of this document is to help users prepare a compatible computational environment before installing the pipeline and downloading large annotation resources.

The pipeline is intended for researchers, students, and bioinformatics practitioners working with human Variant Call Format (VCF) files for rare disease variant annotation and interpretation. The documentation assumes a Linux-based environment, with Ubuntu running natively or through Windows Subsystem for Linux 2 (WSL2).

The recommended development environment for this project is Ubuntu 22.04 LTS or Ubuntu 24.04 LTS with Conda installed for package management.

---

## 2. Hardware Requirements

The pipeline can be executed on a standard desktop or laptop computer for small example datasets. However, larger VCF files and annotation databases require additional memory and storage.

| Component | Minimum Requirement    | Recommended Requirement                      |
| --------- | ---------------------- | -------------------------------------------- |
| CPU       | 2 cores                | 4–8 cores                                    |
| RAM       | 8 GB                   | 16 GB or higher                              |
| Storage   | 50 GB free space       | 100–200 GB free space                        |
| Internet  | Required for downloads | Stable broadband connection                  |
| Display   | Standard monitor       | Full HD recommended for documentation review |

For educational use and small demonstration datasets, the minimum requirements are generally sufficient. For larger clinical or research datasets, the recommended specifications are strongly advised.

---

## 3. Supported Operating Systems

The pipeline is designed primarily for Linux environments. The following operating systems are supported or recommended:

* Ubuntu 22.04 LTS (recommended)
* Ubuntu 24.04 LTS
* Windows 10 or Windows 11 using WSL2 with Ubuntu
* Other Linux distributions may work if the required dependencies are installed correctly

macOS may be compatible for some tools, but it is not the primary target environment for this project.

---

## 4. Required Software

The following general software dependencies are required before installing the bioinformatics tools used in the pipeline.

| Software     | Purpose                                   |
| ------------ | ----------------------------------------- |
| Git          | Version control and repository management |
| Conda        | Package and environment management        |
| Python 3     | Utility scripts and notebook support      |
| Java         | Required for SnpEff and related tools     |
| Perl         | Required for VEP                          |
| Bash         | Pipeline execution and scripting          |
| wget or curl | Downloading databases and resources       |

The exact installation commands and version verification steps will be provided in the Installation Guide.

---

## 5. Bioinformatics Tools

The following bioinformatics tools are used in the generalized variant annotation pipeline.

| Tool     | Purpose                                            |
| -------- | -------------------------------------------------- |
| bcftools | Variant normalization, filtering, and manipulation |
| bgzip    | Compression of VCF files                           |
| tabix    | Indexing compressed VCF files                      |
| VEP      | Functional variant annotation                      |
| SnpEff   | Gene and transcript annotation                     |
| ANNOVAR  | Additional variant annotation                      |
| InterVar | ACMG-based variant classification                  |

These tools work together to convert raw variant calls into functionally annotated and clinically interpretable results.

---

## 6. Annotation Databases

The pipeline relies on several external annotation databases. These databases are not included in the repository and must be downloaded separately.

| Database          | Purpose                                   |
| ----------------- | ----------------------------------------- |
| Ensembl VEP Cache | Transcript and gene annotation            |
| ClinVar           | Clinical significance of variants         |
| gnomAD            | Population allele frequencies             |
| REVEL             | Missense variant pathogenicity prediction |
| AlphaMissense     | AI-based missense prediction              |
| ANNOVAR databases | Additional annotation resources           |
| dbNSFP            | Functional prediction scores (optional)   |

Detailed download instructions, storage locations, and verification steps will be provided in the Database Downloads guide.

---

## 7. Project Directory Structure

The repository is organized into dedicated directories for configuration files, documentation, input data, output results, scripts, and annotation resources.

```text
rare-disease-pipeline-generalized/
├── config/
├── databases/
├── docs/
├── input/
├── modules/
├── notebooks/
├── output/
├── pipeline/
├── scripts/
└── README.md
```

Users should place input VCF files in the `input/` directory and store generated results in the `output/` directory. Annotation databases should be stored in the `databases/` directory or another clearly documented location.

---

## 8. Storage Requirements

The annotation databases used by this pipeline can occupy a significant amount of disk space. The following estimates are approximate and may vary depending on the selected database versions.

| Resource                | Approximate Size        |
| ----------------------- | ----------------------- |
| Repository source files | < 100 MB                |
| Example input data      | 10–500 MB               |
| VEP cache               | 10–20 GB                |
| ClinVar database        | 200–500 MB              |
| gnomAD subset           | Several GB              |
| REVEL database          | 1–5 GB                  |
| AlphaMissense database  | Several GB              |
| ANNOVAR databases       | Variable                |
| Output files            | Depends on dataset size |

A minimum of 50 GB of free disk space is recommended for testing with small datasets. For practical annotation work with multiple databases, 100–200 GB of free space is recommended.

---

## 9. Verification Checklist

Before running the pipeline, verify that the following prerequisites are available.

* Git is installed and accessible from the command line.
* Conda is installed and functioning correctly.
* Python 3 is available.
* Java is installed.
* Perl is installed.
* Bash shell is available.
* bcftools is installed.
* bgzip is installed.
* tabix is installed.
* VEP is installed.
* SnpEff is installed.
* ANNOVAR is installed.
* InterVar is installed.
* Required annotation databases have been downloaded.
* The repository directory structure has been created correctly.
* Sufficient disk space is available.

The exact verification commands for each dependency will be provided in `docs/03_Installation_Guide.md`.
