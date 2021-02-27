# GUNZIP module

## params.options

- publish_dir, publish directory, default '.'
- publish_mode, publish mode, default 'copy'
- publish_enabled, publish enabled, defaul false
- args, arguments for gunzip command

## input

- path archive, archive file path

## output

- path "$gunzip", emit: gunzip
- path "gunzip.version.txt", emit: version
