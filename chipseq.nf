/*
 * There are three steps to use the remote module
 * 1. download loadmodule.groovy from remote file
 * 2. the module must be one file module
 * 3. load it outside of workflow or process
 */
params.options = [:]

def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
  loadScriptByName("lib/loadmodule.groovy")
}
this.metaClass.mixin library

include { CHECKSUM } from loadModule('checksum', 'master') addParams(options: [publish_dir: "md5"])

workflow CHIPSEQ {
  main:

  Channel.fromPath(params.input)
         .splitCsv(header: true)
         .map{ row ->
            fq1 = row.remove("fastq_1")
            fq2 = row.remove("fastq_2")
            def meta = row.clone()
            meta.id = row.group + "_R" + row.replicate
            meta.single_end = fq2 == ""
            [meta, [fq1, fq2]]}
         .set{ch_fastq}

  CHECKSUM(ch_fastq)
}
