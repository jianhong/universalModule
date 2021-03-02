# TRIMGALORE module

Trim reads by trim_galore tool.

## params.options

- publish_dir, publish directory, default 'trimmed'
- publish_mode, publish mode, default 'copy'
- publish_enabled, publish enabled, default true
- args, arguments for trim_galore, default ''
- clip_r1: 0
- clip_r2: 0
- three_prime_clip_r1: 0
- three_prime_clip_r2: 0

## labels

- process_medium

## input

- tuple val(meta), path(reads); meta must contain keys id and single_end

## output

- tuple val(meta), path("*.fq.gz"), emit: reads
- tuple val(meta), path("*.html"), emit: html optional true
- tuple val(meta), path("*.zip"), emit: zip optional true
- tuple val(meta), path("*report.txt"), emit: log
- path "trimgalore.version.txt", emit: version
