# Troubleshooting

---

# 1. Introduction

This document provides solutions to common issues that may occur while installing, configuring, and running the Generalized Rare Disease Variant Annotation Pipeline. Many of these issues are based on practical experience during the development of the pipeline, while others represent common problems encountered when using the included bioinformatics tools.

When troubleshooting, always consult the relevant log files before repeating an analysis. Error messages often indicate the root cause of the problem.

---

# 2. Installation Problems

## Problem

Software installation fails.

### Possible Causes

- Internet connection interrupted.
- Missing system dependencies.
- Insufficient permissions.
- Outdated package lists.

### Solution

```bash
sudo apt update
sudo apt upgrade -y
```

Retry the installation after updating the system.

---

## Problem

Conda environment cannot be activated.

### Possible Causes

- Conda was not initialized.
- Incorrect environment name.

### Solution

```bash
conda init
source ~/.bashrc
conda activate annotation
```

---

# 3. VCF Format Issues

## Problem

The pipeline reports an invalid VCF file.

### Possible Causes

- Missing VCF header.
- Incorrect column formatting.
- Invalid chromosome names.
- Corrupted file.

### Solution

Validate the file using:

```bash
bcftools view input.vcf
```

Correct formatting issues before proceeding.

---

# 4. Reference Genome Mismatch

## Problem

Variants cannot be annotated correctly.

### Possible Causes

- Input VCF uses GRCh37 while annotation databases use GRCh38.
- Chromosome naming conventions differ.

### Solution

Verify that all resources use the same reference genome.

Examples:

- GRCh38
- hg38

Avoid mixing genome assemblies.

---

# 5. bcftools Errors

## Problem

Normalization fails.

### Possible Causes

- Incorrect reference genome.
- Corrupted VCF.
- Invalid REF allele.

### Solution

Confirm that the reference genome matches the VCF and rerun the normalization step.

---

# 6. VEP Issues

## Problem

VEP cannot find the cache.

### Possible Causes

- Cache not downloaded.
- Incorrect cache directory.
- Wrong cache version.

### Solution

Verify the cache location and reinstall the cache if required.

Example:

```bash
perl INSTALL.pl
```

---

## Problem

Plugin not found.

### Possible Causes

- Plugin not installed.
- Incorrect plugin directory.
- Plugin filename incorrect.

### Solution

Confirm that the plugin is located in the configured plugins directory and that the required data files are available.

---

# 7. SnpEff Problems

## Problem

Database not found.

### Possible Causes

- Missing SnpEff database.
- Incorrect genome build.

### Solution

Download the appropriate database and verify the configured genome version.

---

# 8. ANNOVAR Problems

## Problem

ANNOVAR annotation fails.

### Possible Causes

- Missing annotation databases.
- Incorrect database directory.
- Unsupported input format.

### Solution

Verify that the required databases have been downloaded and that the input file follows the expected format.

---

# 9. InterVar Problems

## Problem

InterVar cannot classify variants.

### Possible Causes

- Missing ANNOVAR annotations.
- Incorrect input format.
- Missing reference files.

### Solution

Verify that ANNOVAR completed successfully before running InterVar.

---

# 10. Database Problems

## Problem

Database cannot be indexed.

### Possible Causes

- File not compressed with bgzip.
- Corrupted download.

### Solution

Compress the file using:

```bash
bgzip filename.vcf
```

Index it using:

```bash
tabix -p vcf filename.vcf.gz
```

---

# 11. Permission Errors

## Problem

Permission denied.

### Possible Causes

- File ownership issues.
- Insufficient user permissions.

### Solution

Check permissions:

```bash
ls -l
```

Modify permissions if necessary:

```bash
chmod
```

Use `sudo` only when appropriate.

---

# 12. Memory Issues

## Problem

Pipeline terminates unexpectedly.

### Possible Causes

- Insufficient RAM.
- Very large annotation databases.
- Multiple processes running simultaneously.

### Solution

Close unnecessary applications, increase available memory, or process smaller datasets during testing.

---

# 13. Performance Issues

Slow execution may result from:

- Mechanical hard drives.
- Limited RAM.
- Large annotation databases.
- Slow internet during downloads.

Using SSD storage and local database caches significantly improves performance.

---

# 14. Debugging Strategy

When an error occurs:

1. Read the complete error message.
2. Review the relevant log file.
3. Verify software versions.
4. Check database versions.
5. Confirm the reference genome.
6. Test the failing command independently.
7. Repeat the analysis after correcting the issue.

Systematic troubleshooting is generally more effective than rerunning the entire pipeline without identifying the underlying problem.

---

# 15. Frequently Encountered Development Issues

During development of this pipeline, several issues were encountered and resolved, including:

- Missing VEP cache files.
- Plugin configuration errors.
- Missing Perl modules.
- Java version compatibility.
- Incorrect reference genome selection.
- Missing annotation databases.
- Incorrect file paths.
- Conda environment conflicts.

Documenting these issues helps future users reproduce the environment more efficiently.

---

# 16. Summary

Most pipeline issues originate from software configuration, database preparation, or reference genome inconsistencies.

Carefully verifying each component before execution greatly reduces troubleshooting time and improves reproducibility.
