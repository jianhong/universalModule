# SAMTOOLS_SORT module

Sort bam files by samtools.

## params.options

- publish_dir, publish directory, default 'sort'
- publish_mode, publish mode, default 'copy'
- publish_enabled, publish enabled, defaul true
- args, arguments for samtools sort command, default: ""
- suffix, suffix for output file name, default ".sorted"

## labels

- process_medium

## input

- tuple val(meta), path(bam); meta must have key id.

## output

- tuple val(meta), path("*.bam"), emit: bam
- path "samtools.version.txt", emit: version
