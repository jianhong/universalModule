params.options = [:]
options = [publish_dir: 'genome/bwa_index',
           publish_mode: 'copy',
           publish_enabled: false,
           args: '-a bwtsw']
 process BWA_INDEX {
     tag "$fasta"
     label 'process_high'
     publishDir "${params.outdir}/${options.publish_dir}",
         mode: options.publish_mode,
         enabled: options.publish_enabled

     conda (params.enable_conda ? "bioconda::bwa=0.7.17" : null)
     if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
         container "https://depot.galaxyproject.org/singularity/bwa:0.7.17--hed695b0_7"
     } else {
         container "biocontainers/bwa:v0.7.17_cv1"
     }

     input:
     path fasta

     output:
     tuple path("${fasta}.*"), path(fasta), emit: index
     path "bwa.version.txt", emit: version

     script:
     params.options.forEach{key, value -> options[key]=value}
     """
     bwa index $options.args $fasta
     echo \$(bwa 2>&1) | sed 's/^.*Version: //; s/Contact:.*\$//' > bwa.version.txt
     """
 }
