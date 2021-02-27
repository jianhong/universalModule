# UNTAR module

## params.options

- publish_dir, publish directory, default '.'
- publish_mode, publish mode, default 'copy'
- publish_enabled, publish enabled, defaul false
- args, arguments for tar command

## input

- path archive, archive file path

## output

- path "$untar", emit: untar
- path "tar.version.txt", emit: version
