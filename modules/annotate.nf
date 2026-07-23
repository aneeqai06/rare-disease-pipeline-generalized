// modules/annotate.nf
//
// Wraps the existing, unmodified bash engine
// (pipeline/rare_disease_vcf_annotation_pipeline.sh) as a single Nextflow
// process per sample. This is the pragmatic conversion: it gets you
// Nextflow's parallel execution, -resume, and reporting immediately,
// without rewriting years of working bcftools/VEP/SnpEff/ClinVar/
// ClinGen/SpliceAI/ANNOVAR/InterVar/AnnotSV/ClassifyCNV/ISV-CNV
// scripting logic into a dozen separate Nextflow processes.
//
// If/when you want the fully decomposed version (one process per tool,
// like modules/index.nf, modules/align.nf, etc. in a Nextflow-native
// pipeline), see the note at the bottom of this file.

process ANNOTATE_SAMPLE {
    tag "$sample_id"
    publishDir params.outdir, mode: 'copy', saveAs: { fn -> "${sample_id}/${fn}" }

    input:
    tuple val(sample_id), path(snv_vcf), path(cnv_bed), val(assembly), val(expected_gene)
    path config_env
    path engine_script

    output:
    tuple val(sample_id), val(expected_gene), path("out"), emit: result

    script:
    def cnv_flag = (cnv_bed.name != 'NO_FILE') ? "-n ${cnv_bed}" : ""
    """
    mkdir -p out
    bash ${engine_script} \\
        -i ${snv_vcf} \\
        ${cnv_flag} \\
        -o out \\
        -c ${config_env} \\
        -s ${sample_id} \\
        -a ${assembly} \\
        -t ${task.cpus}
    """
}

/*
 * Fully decomposed alternative (stretch goal, not required):
 *
 *   modules/normalize.nf   -> bcftools norm
 *   modules/vep.nf         -> Ensembl VEP
 *   modules/snpeff.nf      -> SnpEff
 *   modules/clinvar.nf     -> SnpSift annotate (ClinVar)
 *   modules/gnomad.nf      -> bcftools annotate (gnomAD)
 *   modules/clingen.nf     -> bcftools annotate (ClinGen dosage BED)
 *   modules/spliceai.nf    -> SpliceAI
 *   modules/annovar.nf     -> table_annovar.pl
 *   modules/intervar.nf    -> InterVar.py
 *   modules/annotsv.nf     -> AnnotSV
 *   modules/classifycnv.nf -> ClassifyCNV.py
 *   modules/isv_cnv.nf     -> ISV-CNV
 *
 * Each would take a VCF channel in and emit a VCF channel out, chained
 * with `.set{}` the way the reference Clinical_Genomics_pipeline repo's
 * modules/index.nf -> align.nf -> sort.nf -> variant.nf chain does. This
 * is a larger, higher-risk rewrite (each step's exact CLI flags would be
 * lifted verbatim out of rare_disease_vcf_annotation_pipeline.sh into its
 * own process) and is worth doing only once the single-process version
 * above is running reliably in your environment.
 */
