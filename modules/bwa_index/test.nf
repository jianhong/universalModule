#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
  loadScriptByName("lib/loadmodule.groovy")
}
this.metaClass.mixin library

params.input = 'https://raw.githubusercontent.com/nf-core/test-datasets/atacseq/reference/genome.fa'
params.outdir = "."

fasta = Channel.fromPath(params.input)

module_file = loadModule('bwa_index', 'master')
include { BWA_INDEX } from "${module_file}"

workflow TEST_BWA_INDEX {
  BWA_INDEX(fasta)
}
