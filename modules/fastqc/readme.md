# FASTQC module

## params.options

- publish_dir, publish directory, default 'fastqc'
- publish_mode, publish mode, default 'copy'
- publish_enabled, publish enabled, default true
- args, arguments for fastqc, default '--quite'

## labels

- process_medium

## input

- tuple val(meta), path(reads); meta must contain keys id and single_end

## output

- tuple val(meta), path("*.html"), emit: html
- tuple val(meta), path("*.zip"), emit: zip
- path "fastqc.version.txt", emit: version
