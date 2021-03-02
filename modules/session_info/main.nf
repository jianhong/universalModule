params.options = [:]
options = [publish_dir: '.',
           publish_mode: 'copy',
           publish_enabled: true,
           args: '']
 process SESSION_INFO {
    tag "$archive"
    publishDir "${params.outdir}/${options.publish_dir}",
       mode: options.publish_mode,
       enabled: options.publish_enabled

    conda (params.enable_conda ? "conda-forge::python=3.8.3" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
      container "https://depot.galaxyproject.org/singularity/python:3.8.3"
    } else {
      container "quay.io/biocontainers/python:3.8.3"
    }

    input:
    path versions

    output:
    path "software_versions.csv", emit: csv
    path 'software_versions_mqc.yaml', emit: yaml

    script:
    params.options.forEach{key, value -> options[key]=value}
    """
    echo $workflow.manifest.version > pipeline.version.txt
    echo $workflow.nextflow.version > nextflow.version.txt
    echo $workflow.manifest.name > pipelinename.version.txt
    echo $workflow.manifest.homePage > pipelienurl.version.txt

    # write scrape_software_versions scripts
    SEP="'"
    SEP=\$SEP\$SEP\$SEP
    cat <<EOT > scrape_software_versions.py
#!/usr/bin/env python
from __future__ import print_function
import os
import re

pipelinename = "pipeline"
pipelineurl = "pipelineurl"

results = {}
version_files = [x for x in os.listdir('.') if x.endswith('.version.txt')]
for version_file in version_files:

    software = version_file.replace('.version.txt','')

    with open(version_file) as fin:
        version = fin.read().strip()

    if software == 'pipelinename':
        pipelinename = version
    elif software == 'pipelineurl':
        pipelineurl = version
    else:
        results[software] = version

results[pipelinename] = results.pop("pipeline")

# Dump to YAML
print (\${SEP}
id: 'software_versions'
section_name: '%s Software Versions'
section_href: '%s'
plot_type: 'html'
description: 'are collected at run time from the software output.'
data: |
    <dl class="dl-horizontal">
\${SEP} % (pipelinename, pipelineurl))
for k,v in sorted(results.items()):
    print("        <dt>{}</dt><dd><samp>{}</samp></dd>".format(k,v))
print ("    </dl>")

# Write out regexes as csv file:
with open('software_versions.csv', 'w') as f:
    for k,v in sorted(results.items()):
        f.write("{}\t{}\n".format(k,v))
EOT
    python scrape_software_versions.py &> software_versions_mqc.yaml
    """
 }
