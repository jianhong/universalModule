# BWA_INDEX module

## params.options

- publish_dir, publish directory, default 'genome/bwa_index'
- publish_mode, publish mode, default 'copy'
- publish_enabled, publish enabled, defaul false
- args, arguments for bwa index command, default: "-a bwtsw"

## labels

- process_high

## input

- path fasta, genome fasta file path

## output

- tuple path("${fasta}.*"), path(fasta), emit: index
- path "bwa.version.txt", emit: version
