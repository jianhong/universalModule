params.options = [:]
options = [publish_dir: 'sort',
           publish_mode: 'copy',
           publish_enabled: true,
           args: '',
           suffix: ".sorted"]
 process SAMTOOLS_SORT {
     tag "$meta.id"
     label 'process_medium'
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
     tuple val(meta), path("*.bam"), emit: bam
     path "samtools.version.txt", emit: version

     script:
     params.options.forEach{key, value -> options[key]=value}
     def prefix   = ioptions.suffix ? "${meta.id}${ioptions.suffix}" : "${meta.id}"
     """
     samtools sort $options.args -@ $task.cpus -o ${prefix}.bam -T $prefix $bam
     echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//' > samtools.version.txt
     """
 }
