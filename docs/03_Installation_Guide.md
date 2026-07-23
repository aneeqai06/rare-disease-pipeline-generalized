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
