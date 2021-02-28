#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
  loadScriptByName("lib/loadmodule.groovy")
}
this.metaClass.mixin library

params.fastq = 'https://raw.githubusercontent.com/nf-core/test-datasets/atacseq/testdata/SRR1822153_1.fastq.gz'
params.outdir = "."

fastq = Channel.fromPath(params.fastq).map{[[id: 'test', single_end: true], it]}

include { TRIMGALORE } from loadModule('trimgalore', 'master') addParams(options: [clip_r1:5, three_prime_clip_r1:3])

workflow TEST_TRIMGALORE {
  TRIMGALORE(fastq)
}
