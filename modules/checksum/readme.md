# CHECKSUM module

Check the checksums for fastq.gz if md5_1 and md5_2 provided in the metadata.
And create checksums for unzipped fastq files.

## params.options

- publish_dir, publish directory, default 'checksum'
- publish_mode, publish mode, default 'copy'
- md5_exec, md5 command, the first output must be checksum.
- gunzip_exec, gunzip command to unzip gz files

## input [meta, [fq1, fq2]]

- meta, map with keys id, md5_1, md5_2
- reads, reads file

## output

- path("md5.*.txt"), emit: md5
