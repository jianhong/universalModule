# universal modules for QiuBio pipelines

The sample files are located at main.nf, and chipseq.nf.

# How to

First, put the following code in the nf file you want to load remote modules.

```nextflow
def download(String module, String branch) {
  remote = "https://raw.githubusercontent.com/jianhong/universalModule/${branch}/modules/"
  ext    = "/main.nf"
  File file = File.createTempFile(module, '.nf');
    file.withOutputStream { out ->
      new URL(remote + module + ext).withInputStream{ from -> out << from; }
    }
    return file.getAbsolutePath().replaceFirst(/.nf$/, '')
}
```

Second, include the modules by download the modules.

```nextflow
checksum_file = download('checksum', 'master')
include { CHECKSUM } from "${checksum_file}" addParams(options: [publish_dir: "checksum"])
```

And call the process within workflow.

```nextflow
workflow {
  take: input_fastq
  main:
  CHECKSUM(input_fastq)
}
```
