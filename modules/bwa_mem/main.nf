params.options = [:]
options = [publish_dir: 'bwa/mem',
           publish_mode: 'copy',
           args: '-M',
           samtools_args: '-h -F 0x0100 -O BAM',
           suffix: '']
 process BWA_MEM {
     tag "$meta.id"
     label 'process_high'
     publishDir "${params.outdir}/${options.publish_dir}",
         mode: options.publish_mode

     conda (params.enable_conda ? "bioconda::bwa=0.7.17" : null)
     if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
         container "https://depot.galaxyproject.org/singularity/bwa:0.7.17--hed695b0_7"
     } else {
         container "biocontainers/bwa:v0.7.17_cv1"
     }

     input:
     tuple val(meta), path(reads)
     tuple path(index), path(fasta)

     output:
     tuple val(meta), path("*.bam"), emit: bam
     path "bwa.version.txt", emit: version

     script:
     params.options.forEach{key, value -> options[key]=value}
     def prefix   = options.suffix ? "${meta.id}${options.suffix}" : "${meta.id}"
     def rg       = meta.read_group ? "-R ${meta.read_group}" : ""
     """
     bwa mem \\
        $options.args \\
        $rg \\
        -t $task.cpus \\
        $fasta \\
        $reads \\
        | samtools view $options.samtools_args -@ $task.cpus -bS -o ${prefix}.bam -
     echo \$(bwa 2>&1) | sed 's/^.*Version: //; s/Contact:.*\$//' > bwa.version.txt
     """
 }
