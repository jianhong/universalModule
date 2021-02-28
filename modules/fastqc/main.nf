params.options = [:]
options = [publish_dir: 'fastqc',
           publish_mode: 'copy',
           publish_enabled: true,
           args: "--quiet"]
 process FASTQC {
     tag "$meta.id"
     label 'process_medium'
     publishDir "${params.outdir}/${options.publish_dir}",
         mode: options.publish_mode,
         enabled: options.publish_enabled

     conda (params.enable_conda ? "bioconda::fastqc=0.11.9" : null)
     if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
         container "https://depot.galaxyproject.org/singularity/fastqc:0.11.9--0"
     } else {
         container "quay.io/biocontainers/fastqc:0.11.9--0"
     }

     input:
     tuple val(meta), path(reads)
     tuple path(index), path(fasta)

     output:
     tuple val(meta), path("*.html"), emit: html
     tuple val(meta), path("*.zip"), emit: zip
     path "fastqc.version.txt", emit: version

     script:
     params.options.forEach{key, value -> options[key]=value}
      if (meta.single_end) {
          """
          [ ! -f  ${meta.id}.fastq.gz ] && ln -s ${reads[0]} ${meta.id}.fastq.gz
          fastqc $options.args --threads $task.cpus ${meta.id}.fastq.gz
          fastqc --version | sed -e "s/FastQC v//g" > fastqc.version.txt
          """
      } else {
          """
          [ ! -f  ${meta.id}_1.fastq.gz ] && ln -s ${reads[0]} ${meta.id}_1.fastq.gz
          [ ! -f  ${meta.id}_2.fastq.gz ] && ln -s ${reads[1]} ${meta.id}_2.fastq.gz
          fastqc $options.args --threads $task.cpus ${meta.id}_1.fastq.gz ${meta.id}_2.fastq.gz
          fastqc --version | sed -e "s/FastQC v//g" > fastqc.version.txt
          """
      }
 }
