# SAMTOOLS_STATS module

run samtools stats, idxstats, and flagstat

## params.options

- publish_dir, publish directory, default 'sort'
- publish_mode, publish mode, default 'copy'
- publish_enabled, publish enabled, defaul true

## input

- tuple val(meta), path(bam), path(bai); meta must have key id.

## output

- tuple val(meta), path("*.stats"), emit: stats
- tuple val(meta), path("*.flagstat"), emit: flagstat
- tuple val(meta), path("*.idxstats"), emit: idxstats
- path "samtools.version.txt", emit: version
