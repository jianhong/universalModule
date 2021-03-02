params.options = [:]
options = [publish_dir: 'genome',
           publish_mode: 'copy',
           publish_enabled: false]
 process CHROM_SIZES {
     tag "$fasta"
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
     path fasta

     output:
     tuple path("${fasta}.sizes"), path(fasta), path("${fasta}.fai"), emit: sizes
     path "samtools.version.txt", emit: version

     script:
     params.options.forEach{key, value -> options[key]=value}
     """
     samtools faidx $fasta
     cut -f 1,2 ${fasta}.fai > ${fasta}.sizes
     echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//' > samtools.version.txt
     """
 }
