# CHROM_SIZES module

Create chrom_size file.

## params.options

- publish_dir, publish directory, default 'genome'
- publish_mode, publish mode, default 'copy'
- publish_enabled, publish enabled, defaul false

## input

- path fasta, genome fasta file path

## output

- tuple path("${fasta}.sizes"), path(fasta), path("${fasta}.fai"), emit: sizes
- path "samtools.version.txt", emit: version
