# SAMTOOLS_INDEX module

Index bam files by samtools.

## params.options

- publish_dir, publish directory, default '.'
- publish_mode, publish mode, default 'copy'
- publish_enabled, publish enabled, defaul true

## input

- tuple val(meta), path(bam); meta must have key id.

## output

- tuple val(meta), path(bam), path("*.bai"), emit: bai
- path "samtools.version.txt", emit: version
