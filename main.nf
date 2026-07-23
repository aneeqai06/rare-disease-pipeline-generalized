#!/usr/bin/env nextflow
/*
 * main.nf
 *
 * Optional Nextflow orchestrator. Reads the SAME config/sample_sheet.tsv
 * used by pipeline/run_batch_pipeline.sh, and calls the SAME unmodified
 * bash engine (pipeline/rare_disease_vcf_annotation_pipeline.sh) once per
 * row -- but lets Nextflow handle parallel execution across samples,
 * -resume, and the execution report/timeline instead of doing that by
 * hand in bash.
 *
 * No disease or sample name is hardcoded anywhere in this file -- exactly
 * like run_batch_pipeline.sh, everything comes from the sample sheet.
 *
 * Usage:
 *   nextflow run main.nf -profile test
 *   nextflow run main.nf --sample_sheet config/sample_sheet.tsv \
 *                         --config_env config/annotation_resources.env
 *   nextflow run main.nf -resume
 */

nextflow.enable.dsl = 2

include { ANNOTATE_SAMPLE } from './modules/annotate.nf'
include { QC_CHECK }        from './modules/qc.nf'

workflow {

    // One row per sample/disease -> one Nextflow task, run in parallel
    // where resources allow.
    samples_ch = Channel
        .fromPath(params.sample_sheet)
        .splitCsv(header: true, sep: '\t')
        .map { row ->
            tuple(
                row.sample_id,
                file(row.snv_vcf),
                (row.cnv_bed && row.cnv_bed != '-') ? file(row.cnv_bed) : file('NO_FILE'),
                row.assembly ?: 'GRCh38',
                row.expected_gene ?: ''
            )
        }

    annotated_ch = ANNOTATE_SAMPLE(
        samples_ch,
        file(params.config_env),
        file(params.engine)
    )

    QC_CHECK(
        annotated_ch,
        file(params.qc_script)
    )
}
