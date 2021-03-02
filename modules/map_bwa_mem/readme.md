# MAP_BWA_MEM module

Run bwa map and generate stats for the mapping file.

## params.options

- publish_dir, publish directory, default 'bwa/mem'
- publish_mode, publish mode, default 'copy'
- publish_enabled, publish enabled, defaults false
- args, arguments for bwa mem command, default "-M"
- samtools_args, arguments for samtools view command, default "-h -F 0x0100 -O BAM"
- suffix, suffix for output file name, default ""

## labels

- process_high

## input

- tuple val(meta), path(reads)
- tuple path(index), path(fasta)

## output

- tuple val(meta), path(bam), path(bai), emit: bam
- tuple val(meta), path("*.stats"), emit: stats
- tuple val(meta), path("*.flagstat"), emit: flagstat
- tuple val(meta), path("*.idxstats"), emit: idxstats
- path "bwa.version.txt", emit: version
- path "samtools.version.txt", emit: version
