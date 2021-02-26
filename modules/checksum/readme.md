# CHECKSUM module

# params.options

- publish_dir, publish directory
- publish_mode, publish mode
- md5_exec, md5 command, the first output must be checksum.
- gunzip_exec, gunzip command to unzip gz files

# input [meta, [fq1, fq2]]

- meta, map with keys id, md5_1, md5_2
- reads, reads file
