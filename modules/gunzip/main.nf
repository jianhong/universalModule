params.options = [:]
options = [publish_dir: '.',
           publish_mode: 'copy',
           publish_enabled: false,
           args: '']
 process GUNZIP {
     tag "$archive"
     publishDir "${params.outdir}/${options.publish_dir}",
         mode: options.publish_mode,
         enabled: options.publish_enabled

     conda (params.enable_conda ? "conda-forge::sed=4.7" : null)
     if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
         container "https://containers.biocontainers.pro/s3/SingImgsRepo/biocontainers/v1.2.0_cv1/biocontainers_v1.2.0_cv1.img"
     } else {
         container "biocontainers/biocontainers:v1.2.0_cv1"
     }

     input:
     path archive

     output:
     path "$gunzip",       emit: gunzip
     path "gunzip.version.txt", emit: version

     script:
     params.options.forEach{key, value -> options[key]=value}
     gunzip       = archive.toString() - '.gz'
     """
     gunzip -f $options.args $archive
     echo \$(gunzip --version 2>&1) | sed 's/^.*(gzip) //; s/ Copyright.*\$//' > gunzip.version.txt
     """
 }
