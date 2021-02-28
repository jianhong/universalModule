params.options = [:]
options = [publish_dir: '.',
           publish_mode: 'copy',
           publish_enabled: true]
 process SAMTOOLS_INDEX {
     tag "$meta.id"
     publishDir "${params.outdir}/${options.publish_dir}",
         mode: options.publish_mode,
         enabled: options.publish_enabled

     conda (params.enable_conda ? "bioconda::samtools=1.09" : null)
     if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
         container "https://depot.galaxyproject.org/singularity/samtools:1.10--h9402c20_2"
     } else {
         container "quay.io/biocontainers/samtools:1.10--h9402c20_2"
     }

     input:
     tuple val(meta), path(bam)

     output:
     tuple val(meta), path(bam), path("*.bai"), emit: bai
     path "samtools.version.txt", emit: version

     script:
     params.options.forEach{key, value -> options[key]=value}
     """
     samtools index $bam
     echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//' > samtools.version.txt
     """
 }
