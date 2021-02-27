#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
  loadScriptByName("lib/loadmodule.groovy")
}
this.metaClass.mixin library

params.input = "https://raw.githubusercontent.com/jianhong/MintChIP/master/testdata/copy_1.fastq.gz"
params.outdir = "."

archive = Channel.fromPath(params.input)

module_file = loadModule('gunzip', 'master')
include { GUNZIP } from "${module_file}"

workflow TEST_GUNZIP {
  GUNZIP(archive)
}
