# universal modules for QiuBio pipelines

The sample files are located at main.nf, and chipseq.nf.

## How to

First, put the following code in the top of nextflow file you want to load remote modules.

```nextflow
def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
  loadScriptByName("lib/loadmodule.groovy")
}
this.metaClass.mixin library
```

Second, include the modules by download the modules.
The first parameter of loadModule is the module folder name.
The second parameter is the branch name.

```nextflow
include { CHECKSUM } from loadModule('checksum', 'master') addParams(options: [publish_dir: "md5"])

```

And call the process within workflow.

```nextflow
workflow {
  take: input_fastq
  main:
  CHECKSUM(input_fastq)
}
```

## Available modules

- [bwa_index](bwa_index.html)
- [bwa_mem](bwa_mem.html)
- [checksum](checksum.html)
- [gunzip](gunzip.html)
- [md_html](md_html.html)
- [untar](untar.html)