params.options = [:]
options = [publish_dir: 'trimmed',
           publish_mode: 'copy',
           publish_enabled: true,
           args: "",
           clip_r1: 0,
           clip_r2: 0,
           three_prime_clip_r1: 0,
           three_prime_clip_r2: 0]
 process TRIMGALORE {
     tag "$meta.id"
     label 'process_medium'
     publishDir "${params.outdir}/${options.publish_dir}",
         mode: options.publish_mode,
         enabled: options.publish_enabled

     conda (params.enable_conda ? "bioconda::cutadapt=1.18 bioconda::trim-galore=0.6.6" : null)
     if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
         container "https://depot.galaxyproject.org/singularity/trim-galore:0.6.5--0"
     } else {
         container "quay.io/biocontainers/trim-galore:0.6.5--0"
     }

     input:
     tuple val(meta), path(reads)

     output:
     tuple val(meta), path("*.fq.gz"), emit: reads
     tuple val(meta), path("*.html"), emit: html optional true
     tuple val(meta), path("*.zip"), emit: zip optional true
     tuple val(meta), path("*report.txt"), emit: log
     path "trimgalore.version.txt", emit: version

     script:
     params.options.forEach{key, value -> options[key]=value}
     def cores = 1
     if (task.cpus) {
        cores = (task.cpus as int) - 4
        if (meta.single_end) cores = (task.cpus as int) - 3
        if (cores < 1) cores = 1
        if (cores > 4) cores = 4
     }
     // Clipping presets have to be evaluated in the context of SE/PE
      def c_r1 = options.clip_r1 > 0 ? "--clip_r1 ${options.clip_r1}" : ''
      def c_r2 = options.clip_r2 > 0 ? "--clip_r2 ${options.clip_r2}" : ''
      def tpc_r1 = options.three_prime_clip_r1 > 0 ? "--three_prime_clip_r1 ${options.three_prime_clip_r1}" : ''
      def tpc_r2 = options.three_prime_clip_r2 > 0 ? "--three_prime_clip_r2 ${options.three_prime_clip_r2}" : ''

      if (meta.single_end) {
          """
          [ ! -f  ${meta.id}.fastq.gz ] && ln -s $reads[0] ${meta.id}.fastq.gz
          trim_galore \\
              $options.args \\
              --cores $cores \\
              --gzip \\
              $c_r1 \\
              $tpc_r1 \\
              ${meta.id}.fastq.gz
          echo \$(trim_galore --version 2>&1) | sed 's/^.*version //; s/Last.*\$//' > ${software}.version.txt
          """
      } else {
          """
          [ ! -f  ${meta.id}_1.fastq.gz ] && ln -s ${reads[0]} ${meta.id}_1.fastq.gz
          [ ! -f  ${meta.id}_2.fastq.gz ] && ln -s ${reads[1]} ${meta.id}_2.fastq.gz
          trim_galore \\
              $options.args \\
              --cores $cores \\
              --paired \\
              --gzip \\
              $c_r1 \\
              $c_r2 \\
              $tpc_r1 \\
              $tpc_r2 \\
              ${meta.id}_1.fastq.gz \\
              ${meta.id}_2.fastq.gz
          echo \$(trim_galore --version 2>&1) | sed 's/^.*version //; s/Last.*\$//' > ${software}.version.txt
          """
      }
 }
