params.options = [:]
options = [publish_dir: 'checksum',
           publish_mode: 'copy',
           md5_exec : "md5sum",
           gunzip_exec : "gunzip"]
process CHECKSUM {
  tag "$meta.id"
  publishDir "${params.outdir}/${options.publish_dir}",
             mode: options.publish_mode

   conda (params.enable_conda ? "conda-forge::sed=4.7" : null)
   if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
       container "https://containers.biocontainers.pro/s3/SingImgsRepo/biocontainers/v1.2.0_cv1/biocontainers_v1.2.0_cv1.img"
   } else {
       container "biocontainers/biocontainers:v1.2.0_cv1"
   }

  input: tuple val(meta), path(reads)
  output:
  path("md5.*.txt"), emit: md5
  
  script:
  def prefix = meta.id
  params.options.forEach{key, value -> options[key]=value}
  if (meta.single_end) {
        """
        touch md5.${prefix}.txt
        [ ! -f  ${prefix}.fastq.gz ] && ln -s ${reads[0]} ${prefix}.fastq.gz
        ${options.gunzip_exec} -c ${prefix}.fastq.gz > ${prefix}.fastq
        ${options.md5_exec} ${prefix}.fastq >>md5.${prefix}.txt
        if [ "${meta.md5_1}" != "null" ]; then
            md5=(\$(${options.md5_exec} ${prefix}.fastq.gz))
            if [ "\$md5" != "${meta.md5_1}" ]
            then
                echo "${meta.id} has checksum ${meta.md5_1}, but we got checksum \$md5!"
                exit 128
            fi
        fi
        """
    } else {
        """
        touch md5.${prefix}.txt
        [ ! -f  ${prefix}_1.fastq.gz ] && ln -s ${reads[0]} ${prefix}_1.fastq.gz
        [ ! -f  ${prefix}_2.fastq.gz ] && ln -s ${reads[1]} ${prefix}_2.fastq.gz
        ${options.gunzip_exec} -c ${prefix}_1.fastq.gz > ${prefix}_1.fastq
        ${options.md5_exec} ${prefix}_1.fastq >>md5.${prefix}.txt
        ${options.gunzip_exec} -c ${prefix}_2.fastq.gz > ${prefix}_2.fastq
        ${options.md5_exec} ${prefix}_2.fastq >>md5.${prefix}.txt
        if [ "${meta.md5_1}" != "null" ]; then
            md5=(\$(${options.md5_exec} ${prefix}_1.fastq.gz))
            if [ "\$md5" != "${meta.md5_1}" ]
            then
                echo "${meta.id} has checksum ${meta.md5_1}, but we got checksum \$md5!"
                exit 128
            fi
        fi
        if [ "${meta.md5_2}" != "null" ]; then
            md5=(\$(${options.md5_exec} ${prefix}_2.fastq.gz))
            if [ "\$md5" != "${meta.md5_2}" ]
            then
                echo "${meta.id} has checksum ${meta.md5_2}, but we got checksum \$md5!"
                exit 128
            fi
        fi
        """
    }
}
