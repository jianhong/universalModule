# SESSION_INFO module

Extract all software versions from version text file for multiQC

## params.options

- publish_dir, publish directory, default '.'
- publish_mode, publish mode, default 'copy'
- publish_enabled, publish enabled, default true

## input

- path versions

## output

- path "software_versions.csv", emit: csv
- path 'software_versions_mqc.yaml', emit: yaml
