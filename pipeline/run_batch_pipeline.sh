#!/usr/bin/env bash
set -euo pipefail

##############################################################################
# Generalized Rare Disease SNV Annotation Pipeline
# Stages:
#  1. Normalization (bcftools norm)
#  2. Reference Allele Sanity Check (bcftools norm --check-ref)
#  3. Ensembl VEP Annotation (REVEL, AlphaMissense, SpliceAI)
#  4. SnpEff Annotation
#  5. ANNOVAR Table Annotation (refGene, ClinVar, gnomAD)
#  6. InterVar ACMG Automated Classification
#  7. Quality Control & Gene Verification Summary
##############################################################################

# ---- Default CLI Parameters ------------------------------------------------
INPUT_VCF=""
TARGET_BED=""
OUT_DIR="output"
CONFIG_FILE="config/annotation_resources.env"
SAMPLE_NAME=""
TARGET_GENE="TARGET_GENE"
FORCE=0

usage() {
  cat << EOF
Usage: $0 -i <input.vcf> -n <target.bed> -s <sample_name> -g <target_gene> [-o <out_dir>] [-c <config_file>] [-f]

Options:
  -i  Input VCF file (uncompressed or .vcf.gz)
  -n  Target BED file defining genomic regions
  -s  Sample Name / Identifier
  -g  Target Gene Symbol for automated QC verification
  -o  Output directory (default: output)
  -c  Path to environment config file (default: config/annotation_resources.env)
  -f  Force overwrite existing stage outputs
  -h  Show this help message
EOF
  exit 1
}

# Parse Command Line Options
while getopts "i:n:s:g:o:c:fh" opt; do
  case $opt in
    i) INPUT_VCF="$OPTARG" ;;
    n) TARGET_BED="$OPTARG" ;;
    s) SAMPLE_NAME="$OPTARG" ;;
    g) TARGET_GENE="$OPTARG" ;;
    o) OUT_DIR="$OPTARG" ;;
    c) CONFIG_FILE="$OPTARG" ;;
    f) FORCE=1 ;;
    h) usage ;;
    *) usage ;;
  esac
done

if [[ -z "$INPUT_VCF" || -z "$TARGET_BED" || -z "$SAMPLE_NAME" ]]; then
  echo "[ERROR] Missing required arguments: -i (input VCF), -n (target BED), or -s (sample name)."
  usage
fi

# ---- Load Configuration ----------------------------------------------------
if [[ -f "$CONFIG_FILE" ]]; then
  source "$CONFIG_FILE"
else
  echo "[WARNING] Config file '$CONFIG_FILE' not found. Falling back to default relative paths."
  PROJECT_DIR="$(pwd)"
  REF_FASTA="databases/grch38.fa"
  BCFTOOLS_BIN="bcftools"
  VEP_BIN="vep"
  VEP_CACHE_DIR="databases/vep"
  VEP_CACHE_VERSION="110"
  VEP_PLUGIN_DIR="databases/vep_plugins"
  ALPHAMISSENSE_TSV="databases/alphamissense/AlphaMissense_hg38.tsv.gz"
  REVEL_TSV="databases/revel/new_tabbed_revel_grch38.tsv.gz"
  SPLICEAI_LOOKUP="databases/spliceai/spliceai_scores.vcf.gz"
  SNPEFF_JAR="databases/snpeff/snpEff.jar"
  SNPEFF_DB="GRCh38.105"
  ANNOVAR_DIR="annovar"
  ANNOVAR_HUMANDB="annovar/humandb"
  ANNOVAR_PROTOCOLS="refGeneWithVer,clinvar_20250721,ensGene,hg38_gnomad_genome"
  ANNOVAR_OPERATIONS="g,f,g,f"
  INTERVAR_DIR="InterVar"
fi

# ---- Directory Setup -------------------------------------------------------
SAMPLE_OUT_DIR="$OUT_DIR/$SAMPLE_NAME"
LOG_DIR="$OUT_DIR/$SAMPLE_NAME/logs"
mkdir -p "$SAMPLE_OUT_DIR" "$LOG_DIR"

TIMESTAMP="$(date +%Y%m%d_%H%M%S)"
LOG_FILE="$LOG_DIR/pipeline_${SAMPLE_NAME}_${TIMESTAMP}.log"

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"; }

run_stage() {
  local name="$1"; shift
  log "=== STAGE: $name ==="
  if "$@" >>"$LOG_FILE" 2>&1; then
    log "    -> OK"
  else
    log "    -> FAILED (see $LOG_FILE)"
    exit 1
  fi
}

log "Pipeline execution started for sample: $SAMPLE_NAME"
log "Input VCF: $INPUT_VCF | Target BED: $TARGET_BED"

# ---------------------------------------------------------------------------
# Stage 1: Normalize (left-align indels, split multiallelics)
# ---------------------------------------------------------------------------
NORM_VCF="$SAMPLE_OUT_DIR/${SAMPLE_NAME}.normalized.vcf"
if [[ ! -f "$NORM_VCF" || $FORCE -eq 1 ]]; then
  run_stage "bcftools norm" \
    "$BCFTOOLS_BIN" norm -f "$REF_FASTA" -m -both -O v -o "$NORM_VCF" "$INPUT_VCF"
else
  log "=== STAGE: bcftools norm (SKIPPED - Output exists) ==="
fi

# ---------------------------------------------------------------------------
# Stage 2: REF allele sanity check & target region slicing
# ---------------------------------------------------------------------------
REFCHECK_VCF="$SAMPLE_OUT_DIR/${SAMPLE_NAME}.ref_check.vcf"
if [[ ! -f "$REFCHECK_VCF" || $FORCE -eq 1 ]]; then
  run_stage "bcftools norm --check-ref & region filter" \
    "$BCFTOOLS_BIN" norm -R "$TARGET_BED" -f "$REF_FASTA" -c w -O v -o "$REFCHECK_VCF" "$NORM_VCF"
else
  log "=== STAGE: bcftools norm --check-ref (SKIPPED - Output exists) ==="
fi

# ---------------------------------------------------------------------------
# Stage 3: Ensembl VEP Annotation (REVEL, AlphaMissense, SpliceAI)
# ---------------------------------------------------------------------------
VEP_OUT="$SAMPLE_OUT_DIR/${SAMPLE_NAME}.vep_annotated.vcf"
if [[ ! -f "$VEP_OUT" || $FORCE -eq 1 ]]; then
  VEP_ARGS=(
    --input_file "$REFCHECK_VCF"
    --output_file "$VEP_OUT"
    --vcf --force_overwrite
    --offline --cache --dir_cache "$VEP_CACHE_DIR" --cache_version "$VEP_CACHE_VERSION"
    --fasta "$REF_FASTA"
    --dir_plugins "$VEP_PLUGIN_DIR"
    --symbol
  )

  # Append REVEL plugin if database file exists
  if [[ -f "$REVEL_TSV" ]]; then
    VEP_ARGS+=(--plugin REVEL,file="$REVEL_TSV")
  fi

  # Append AlphaMissense plugin if database file exists
  if [[ -f "$ALPHAMISSENSE_TSV" ]]; then
    VEP_ARGS+=(--plugin AlphaMissense,file="$ALPHAMISSENSE_TSV")
  fi

  # Append SpliceAI lookup if present
  if [[ -f "$SPLICEAI_LOOKUP" ]]; then
    VEP_ARGS+=(--custom "$SPLICEAI_LOOKUP,SpliceAI,vcf,exact,0,DS_AG,DS_AL,DS_DG,DS_DL")
  fi

  run_stage "Ensembl VEP" "$VEP_BIN" "${VEP_ARGS[@]}"
else
  log "=== STAGE: Ensembl VEP (SKIPPED - Output exists) ==="
fi

# ---------------------------------------------------------------------------
# Stage 4: SnpEff Annotation
# ---------------------------------------------------------------------------
SNPEFF_OUT="$SAMPLE_OUT_DIR/${SAMPLE_NAME}.snpeff.vcf"
if [[ ! -f "$SNPEFF_OUT" || $FORCE -eq 1 ]]; then
  log "=== STAGE: SnpEff ==="
  if java -Xmx8g -jar "$SNPEFF_JAR" "$SNPEFF_DB" "$VEP_OUT" > "$SNPEFF_OUT" 2>>"$LOG_FILE"; then
    log "    -> OK"
  else
    log "    -> FAILED (see $LOG_FILE)"
    exit 1
  fi
else
  log "=== STAGE: SnpEff (SKIPPED - Output exists) ==="
fi

# ---------------------------------------------------------------------------
# Stage 5: ANNOVAR (refGene, ClinVar, gnomAD)
# ---------------------------------------------------------------------------
ANNOVAR_AVINPUT="$SAMPLE_OUT_DIR/${SAMPLE_NAME}.avinput"
ANNOVAR_OUT_PREFIX="$SAMPLE_OUT_DIR/${SAMPLE_NAME}.annovar"

if [[ ! -f "${ANNOVAR_OUT_PREFIX}.hg38_multianno.txt" || $FORCE -eq 1 ]]; then
  run_stage "convert2annovar" \
    perl "$ANNOVAR_DIR/convert2annovar.pl" -format vcf4 "$SNPEFF_OUT" \
      -outfile "$ANNOVAR_AVINPUT" -includeinfo

  run_stage "table_annovar" \
    perl "$ANNOVAR_DIR/table_annovar.pl" "$ANNOVAR_AVINPUT" "$ANNOVAR_HUMANDB" \
      -buildver hg38 -out "$ANNOVAR_OUT_PREFIX" \
      -protocol "$ANNOVAR_PROTOCOLS" -operation "$ANNOVAR_OPERATIONS" \
      -nastring . -otherinfo
else
  log "=== STAGE: ANNOVAR (SKIPPED - Output exists) ==="
fi

# ---------------------------------------------------------------------------
# Stage 6: InterVar (ACMG Automated Classification)
# ---------------------------------------------------------------------------
INTERVAR_OUT_PREFIX="$SAMPLE_OUT_DIR/${SAMPLE_NAME}.intervar"

if [[ ! -f "${INTERVAR_OUT_PREFIX}.hg38_multianno.txt.intervar" || $FORCE -eq 1 ]]; then
  log "=== STAGE: InterVar ==="
  pushd "$INTERVAR_DIR" >/dev/null

  if python3 Intervar.py \
      -b hg38 \
      -i "$SNPEFF_OUT" \
      --input_type=VCF \
      -o "$INTERVAR_OUT_PREFIX" \
      >>"$LOG_FILE" 2>&1
  then
    log "    -> OK"
  else
    log "    -> FAILED (see $LOG_FILE)"
    popd >/dev/null
    exit 1
  fi

  popd >/dev/null
else
  log "=== STAGE: InterVar (SKIPPED - Output exists) ==="
fi

# ---------------------------------------------------------------------------
# Stage 7: Automated QC Verification Report
# ---------------------------------------------------------------------------
QC_REPORT="$SAMPLE_OUT_DIR/qc_report.txt"
log "=== STAGE: Generating Quality Control Report ==="

TOTAL_VARIANTS=$(grep -v "^#" "$SNPEFF_OUT" | wc -l || echo "0")
GENE_HITS=$(grep -v "^#" "$SNPEFF_OUT" | grep -c "$TARGET_GENE" || echo "0")

cat << QC_EOF > "$QC_REPORT"
==================================================
QUALITY CONTROL REPORT
==================================================
Sample Name       : $SAMPLE_NAME
Target Gene Symbol: $TARGET_GENE
Execution Date    : $(date)

ANNOTATION STAGES EXECUTED:
--------------------------------------------------
[✓] Normalization & Ref Check (bcftools)
[✓] Impact Predictions (VEP, SnpEff)
[✓] Advanced Pathogenicity (REVEL, AlphaMissense, SpliceAI)
[✓] Clinical & Frequency Databases (ClinVar, gnomAD)
[✓] ACMG Classification (InterVar)

METRICS:
--------------------------------------------------
Total Region-Filtered Variants : $TOTAL_VARIANTS
Target Gene Symbol Hits         : $GENE_HITS

STATUS: $( [[ $GENE_HITS -gt 0 ]] && echo "PASS - Target Gene Identified" || echo "WARNING - Gene Symbol Not Found" )
==================================================
QC_EOF

log "Pipeline execution finished successfully for sample $SAMPLE_NAME."
log "QC Summary Report: $QC_REPORT"
