#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
  loadScriptByName("lib/loadmodule.groovy")
}
this.metaClass.mixin library

params.input = "https://raw.githubusercontent.com/jianhong/chipseq/master/assets/design.csv"
params.outdir = "./results"

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

checksum_file = loadModule('checksum', 'master')
include { CHECKSUM } from "${checksum_file}" addParams(options: [publish_dir: "md5"])

workflow TEST_CHECKSUM {
  CHECKSUM(ch_fastq)
}
