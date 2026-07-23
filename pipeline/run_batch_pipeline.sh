#!/usr/bin/env bash
#
# run_batch_pipeline.sh
#
# Generalized batch orchestrator. Reads a sample sheet (one row per
# disease/sample) and calls the unmodified engine script,
# rare_disease_vcf_annotation_pipeline.sh, once per row. No disease name
# ever appears in this file's code -- only in the data you supply.
#
# Usage:
#   THREADS=4 bash run_batch_pipeline.sh \
#     --sheet config/sample_sheet.tsv \
#     --config config/annotation_resources.env \
#     [--only SAMPLE_ID] \
#     [--force] \
#     [--engine pipeline/rare_disease_vcf_annotation_pipeline.sh] \
#     [--results-dir results]
#
# Sample sheet format (tab-separated, header required):
#   sample_id  snv_vcf  cnv_bed  assembly  expected_gene  notes
#
#   cnv_bed and expected_gene may be left empty (use "-" or blank).

set -Eeuo pipefail
IFS=$'\n\t'

SHEET=""
CONFIG=""
ONLY=""
FORCE=0
ENGINE="pipeline/rare_disease_vcf_annotation_pipeline.sh"
RESULTS_DIR="results"
THREADS="${THREADS:-4}"

usage() {
  cat <<'USAGE'
Usage:
  THREADS=4 bash run_batch_pipeline.sh --sheet SHEET.tsv --config CONFIG.env \
    [--only SAMPLE_ID] [--force] [--engine PATH] [--results-dir DIR]
USAGE
}

log()  { printf '[%s] %s\n' "$(date '+%F %T')" "$*" >&2; }
die()  { printf '[ERROR] %s\n' "$*" >&2; exit 1; }

while [[ $# -gt 0 ]]; do
  case "$1" in
    --sheet)       SHEET="$2"; shift 2 ;;
    --config)      CONFIG="$2"; shift 2 ;;
    --only)        ONLY="$2"; shift 2 ;;
    --force)       FORCE=1; shift ;;
    --engine)      ENGINE="$2"; shift 2 ;;
    --results-dir) RESULTS_DIR="$2"; shift 2 ;;
    -h|--help)     usage; exit 0 ;;
    *) die "Unknown argument: $1" ;;
  esac
done

[[ -n "$SHEET"  ]] || { usage; die "Missing --sheet"; }
[[ -n "$CONFIG" ]] || { usage; die "Missing --config"; }
[[ -s "$SHEET"  ]] || die "Sample sheet not found or empty: $SHEET"
[[ -s "$CONFIG" ]] || die "Config file not found or empty: $CONFIG"
[[ -x "$ENGINE" || -f "$ENGINE" ]] || die "Engine script not found: $ENGINE"

mkdir -p "$RESULTS_DIR"
SUMMARY="$RESULTS_DIR/batch_summary.tsv"
echo -e "sample_id\tstatus\tqc_expected_gene\tqc_result\tresult_dir\tlog_file" > "$SUMMARY"

# --- parse header to find column positions, so column order in the sheet
#     can vary without breaking anything -----------------------------------
header=$(head -n1 "$SHEET")
declare -A COL
i=1
for col in $header; do
  COL[$col]=$i
  i=$((i + 1))
done

for required in sample_id snv_vcf; do
  [[ -n "${COL[$required]:-}" ]] || die "Sample sheet is missing required column: $required"
done

get_field() {
  # get_field "<tab-separated line>" "<column name>"
  local line="$1" name="$2" idx
  idx="${COL[$name]:-}"
  [[ -n "$idx" ]] || { echo ""; return; }
  echo "$line" | cut -f "$idx"
}

while IFS=$'\t' read -r line || [[ -n "$line" ]]; do
  [[ -z "$line" ]] && continue
  case "$line" in ''|'#'*) continue ;; esac
  full_line="$line"

  sample_id=$(get_field "$full_line" "sample_id")
  snv_vcf=$(get_field "$full_line" "snv_vcf")
  cnv_bed=$(get_field "$full_line" "cnv_bed")
  assembly=$(get_field "$full_line" "assembly")
  expected_gene=$(get_field "$full_line" "expected_gene")

  [[ -n "$sample_id" ]] || continue
  assembly="${assembly:-GRCh38}"

  if [[ -n "$ONLY" && "$sample_id" != "$ONLY" ]]; then
    continue
  fi

  out_dir="$RESULTS_DIR/$sample_id"
  log_file="$out_dir/logs/${sample_id}.pipeline.log"

  if [[ -d "$out_dir" && -s "$log_file" && "$FORCE" -eq 0 ]]; then
    log "Skipping $sample_id: results already exist at $out_dir (use --force to re-run)"
    echo -e "${sample_id}\tSKIPPED_EXISTING\t${expected_gene}\t-\t${out_dir}\t${log_file}" >> "$SUMMARY"
    continue
  fi

  if [[ "$FORCE" -eq 1 && -d "$out_dir" ]]; then
    log "Removing existing results for $sample_id (--force)"
    rm -rf "$out_dir"
  fi

  [[ -s "$snv_vcf" ]] || { log "SKIP $sample_id: snv_vcf missing/empty: $snv_vcf"; continue; }

  cnv_args=()
  if [[ -n "$cnv_bed" && "$cnv_bed" != "-" && -s "$cnv_bed" ]]; then
    cnv_args=(-n "$cnv_bed")
  fi

  log "Running sample: $sample_id (assembly=$assembly)"
  set +e
  bash "$ENGINE" \
    -i "$snv_vcf" \
    "${cnv_args[@]}" \
    -o "$out_dir" \
    -c "$CONFIG" \
    -s "$sample_id" \
    -a "$assembly" \
    -t "$THREADS"
  rc=$?
  set -e

  qc_result="-"
  if [[ -n "$expected_gene" && "$expected_gene" != "-" ]]; then
    final_vcf="$out_dir/snv/${sample_id}.final.small_variants.annotated.vcf.gz"
    if [[ -s "$final_vcf" ]] && bcftools view "$final_vcf" 2>/dev/null | grep -qw "$expected_gene"; then
      qc_result="PASS"
    else
      qc_result="WARN_gene_not_found"
    fi
  fi

  if [[ $rc -eq 0 ]]; then
    log "Finished $sample_id (QC: $qc_result)"
    echo -e "${sample_id}\tOK\t${expected_gene}\t${qc_result}\t${out_dir}\t${log_file}" >> "$SUMMARY"
  else
    log "FAILED $sample_id (exit code $rc) — see $log_file"
    echo -e "${sample_id}\tFAILED\t${expected_gene}\t${qc_result}\t${out_dir}\t${log_file}" >> "$SUMMARY"
  fi
done < <(tail -n +2 "$SHEET")

log "Batch complete. Summary: $SUMMARY"
column -t "$SUMMARY" >&2 || cat "$SUMMARY" >&2
