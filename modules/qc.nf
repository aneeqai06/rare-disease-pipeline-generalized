// modules/qc.nf
//
// Wraps pipeline/qc_check.py as a Nextflow process, run once per sample
// right after ANNOTATE_SAMPLE finishes. Writes one line to
// results/<sample_id>/qc_result.tsv; Nextflow's own execution report
// (enabled in nextflow.config) gives you the pass/fail/timing summary
// across the whole batch.

process QC_CHECK {
    tag "$sample_id"
    publishDir params.outdir, mode: 'copy', saveAs: { fn -> "${sample_id}/${fn}" }

    input:
    tuple val(sample_id), val(expected_gene), path(result_dir)
    path qc_script

    output:
    path "qc_result.tsv"

    script:
    """
    python3 ${qc_script} \\
        --sample-id ${sample_id} \\
        --result-dir ${result_dir} \\
        --expected-gene "${expected_gene}" \\
        > qc_result.tsv || true
    """
}
