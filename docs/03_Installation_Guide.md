# Installation Guide

---

# 1. Introduction

This guide provides detailed instructions for installing, configuring, and verifying all software required to run the **Generalized Rare Disease Variant Annotation Pipeline**.

The pipeline has been designed for Linux-based systems and has been developed and tested using **Ubuntu running under Windows Subsystem for Linux (WSL2)**. While native Linux distributions are also supported, this guide primarily focuses on Ubuntu because it provides excellent compatibility with the bioinformatics software used throughout the project.

The installation process is divided into several logical stages:

1. Preparing the operating system
2. Installing package managers
3. Installing required programming languages
4. Installing bioinformatics software
5. Downloading annotation databases
6. Verifying the installation

Following these steps ensures that all software components are correctly configured before running the annotation pipeline.

---

# 2. Before You Begin

Before installing any software, ensure that the following requirements are met.

## Hardware

| Component | Minimum | Recommended |
|-----------|----------|-------------|
| CPU | 4 cores | 8+ cores |
| RAM | 8 GB | 16–32 GB |
| Storage | 50 GB free | 150 GB+ |
| Internet | Stable broadband | High-speed broadband |

Large annotation databases such as VEP cache, ClinVar, AlphaMissense, and gnomAD require significant storage space.

---

## Operating System

The pipeline has been developed for:

- Ubuntu 22.04 LTS
- Ubuntu 24.04 LTS
- Windows 10/11 with WSL2
- Native Linux distributions (Ubuntu recommended)

macOS users may also be able to run the pipeline with minor modifications, although this configuration has not been validated as part of the project.

---

## User Permissions

The installation process assumes that the user has:

- sudo privileges
- Internet access
- Permission to install software
- Permission to create Conda environments

---

# 3. Installing Ubuntu Using WSL2

Windows Subsystem for Linux (WSL2) allows Linux applications to run natively within Windows without requiring a virtual machine.

If WSL2 has not already been installed, open **PowerShell as Administrator** and execute:

```powershell
wsl --install
```

Restart the computer when prompted.

Install Ubuntu from the Microsoft Store or use:

```powershell
wsl --install -d Ubuntu
```

After installation, launch Ubuntu and create a Linux username and password.

Verify the installation:

```bash
lsb_release -a
```

Expected output:

```
Distributor ID: Ubuntu
Description: Ubuntu 22.04 LTS
```

or

```
Distributor ID: Ubuntu
Description: Ubuntu 24.04 LTS
```

---

# 4. Updating Ubuntu

Always update the operating system before installing bioinformatics software.

```bash
sudo apt update
sudo apt upgrade -y
```

Clean unused packages:

```bash
sudo apt autoremove -y
sudo apt clean
```

Keeping the operating system updated minimizes compatibility issues with package dependencies.

---

# 5. Installing Miniconda

Miniconda is used to manage isolated software environments.

Download the latest Linux installer:

```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
```

Run the installer:

```bash
bash Miniconda3-latest-Linux-x86_64.sh
```

Follow the installation prompts and allow Miniconda to initialize your shell.

Reload the shell:

```bash
source ~/.bashrc
```

Verify the installation:

```bash
conda --version
```

Expected output:

```
conda 25.x.x
```

The exact version may differ depending on the release available at the time of installation.

---

# 6. Creating a Conda Environment

Using dedicated Conda environments prevents conflicts between software packages.

Create a new environment:

```bash
conda create -n annotation python=3.11 -y
```

Activate the environment:

```bash
conda activate annotation
```

Verify:

```bash
python --version
```

Expected output:

```
Python 3.11.x
```

Throughout this documentation, all software installations should be performed inside the activated environment unless otherwise specified.

---

# 7. Installing Git

Git is required for cloning the repository and tracking changes.

Install Git:

```bash
sudo apt install git -y
```

Verify:

```bash
git --version
```

Example output:

```
git version 2.xx.x
```

Configure your Git identity:

```bash
git config --global user.name "Your Name"
git config --global user.email "your_email@example.com"
```

Verify the configuration:

```bash
git config --list
```

---

# 8. Installing Java

Several annotation tools require Java.

Install OpenJDK:

```bash
sudo apt install openjdk-21-jdk -y
```

Verify:

```bash
java --version
```

Example output:

```
openjdk 21
```

Check the compiler:

```bash
javac --version
```

---

# 9. Installing Perl

Ensembl Variant Effect Predictor (VEP) is written in Perl.

Install Perl:

```bash
sudo apt install perl -y
```

Verify:

```bash
perl -v
```

Example output:

```
This is perl 5.xx
```

Install commonly required Perl modules:

```bash
sudo apt install \
libdbi-perl \
libdbd-mysql-perl \
libjson-perl \
libtext-csv-perl \
libwww-perl \
libarchive-zip-perl \
libxml-simple-perl \
-y
```

These modules are commonly required by VEP and associated plugins.

---

# 10. Summary

At this stage, the following components should be successfully installed:

- Ubuntu (WSL2 or native)
- Updated operating system
- Miniconda
- Python
- Git
- Java
- Perl
- Required Perl modules

The next section of this guide covers the installation of the bioinformatics tools required for the annotation pipeline, including **bcftools**, **tabix**, **bgzip**, **Ensembl VEP**, **SnpEff**, **ANNOVAR**, and **InterVar**.
---

# 11. Installing bcftools

## Purpose

`bcftools` is one of the core utilities used throughout this pipeline. It provides tools for manipulating Variant Call Format (VCF) and Binary Call Format (BCF) files, including normalization, filtering, indexing, querying, and validation.

Within this pipeline, `bcftools` is used to:

- Validate VCF files
- Normalize variants
- Left-align insertions and deletions
- Split multiallelic variants
- Compress and index output files
- Perform quality control checks

## Installation

Install bcftools using APT:

```bash
sudo apt update
sudo apt install -y bcftools
```

Alternatively, install through Conda:

```bash
conda install -c bioconda bcftools
```

## Verification

```bash
bcftools --version
```

Expected output:

```
bcftools 1.xx
```

---

# 12. Installing bgzip and tabix

## Purpose

`bgzip` compresses genomic files while preserving random access capability.

`tabix` indexes compressed genomic files for efficient querying.

These tools are essential when working with:

- ClinVar
- gnomAD
- AlphaMissense
- REVEL
- dbNSFP

Most annotation tools require indexed annotation databases.

## Installation

```bash
sudo apt install tabix
```

or

```bash
conda install -c bioconda htslib
```

## Verification

```bash
bgzip --help
```

```bash
tabix --help
```

Both commands should display the program help menu.

---

# 13. Installing Ensembl Variant Effect Predictor (VEP)

## Purpose

The Ensembl Variant Effect Predictor (VEP) predicts the biological consequences of genomic variants. It annotates variants with transcript, gene, protein, and regulatory information using the Ensembl database.

Within this pipeline, VEP performs the primary functional annotation of variants.

## Clone the Repository

```bash
git clone https://github.com/Ensembl/ensembl-vep.git
```

Move into the repository:

```bash
cd ensembl-vep
```

## Install VEP

Run the installer:

```bash
perl INSTALL.pl
```

The installer allows you to download:

- VEP cache
- FASTA reference
- Plugins

These can also be installed separately if preferred.

## Verification

```bash
vep --help
```

The command should display the VEP help page without errors.

---

# 14. Installing the VEP Cache

## Purpose

The VEP cache stores precomputed Ensembl annotations, allowing VEP to annotate variants quickly without querying remote servers.

Using the cache significantly improves annotation speed and reproducibility.

## Installation

Download the cache using the VEP installer:

```bash
perl INSTALL.pl
```

Select:

- Homo sapiens
- GRCh38
- Cache files

The cache will be downloaded to the default VEP cache directory unless a custom location is specified.

## Verification

```bash
vep --cache --help
```

---

# 15. Installing VEP Plugins

## Purpose

VEP plugins extend the annotation capabilities of the Variant Effect Predictor by incorporating additional prediction scores and external resources.

Common plugins used in this pipeline include:

- REVEL
- AlphaMissense
- dbNSFP (optional)

## Installation

Download the required plugin files into the VEP plugins directory.

Ensure that any associated data files (such as REVEL or AlphaMissense score tables) are downloaded, compressed with `bgzip`, and indexed using `tabix`.

## Verification

Run a small test annotation using one of the installed plugins and confirm that the corresponding annotation fields are added to the output.

---

# 16. Installing SnpEff

## Purpose

SnpEff predicts the effects of genomic variants on genes and transcripts. It provides standardized annotations such as coding consequences, amino acid changes, and predicted impact.

Within this project, SnpEff complements VEP by providing an additional annotation source for comparison and downstream analysis.

## Installation

Download the latest SnpEff release from the official repository or install it through Conda.

Using Conda:

```bash
conda install -c bioconda snpeff
```

## Verification

```bash
snpEff -version
```

The installed version should be displayed successfully.

---

# 17. Summary

At this stage, the following software should be installed and verified:

- bcftools
- bgzip
- tabix
- Ensembl VEP
- VEP Cache
- VEP Plugins
- SnpEff

The next section of this guide will cover the installation and configuration of ANNOVAR, InterVar, annotation databases, and final environment verification.
