params.options = [:]
options = [publish_dir: '.',
           publish_mode: 'copy',
           publish_enabled: false,
           args: '']
 process UNTAR {
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
     path "$untar",       emit: untar
     path "tar.version.txt", emit: version

     script:
     params.options.forEach{key, value -> options[key]=value}
     untar        = archive.toString() - '.tar.gz'
     """
     tar -xzvf $options.args $archive
     echo \$(tar --version 2>&1) | sed 's/^.*(GNU tar) //; s/ Copyright.*\$//' > tar.version.txt
     """
 }
