#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
  loadScriptByName("lib/loadmodule.groovy")
}
this.metaClass.mixin library

params.input = "https://github.com/jianhong/chipseq/archive/1.0.3.tar.gz"
params.outdir = "."

archive = Channel.fromPath(params.input)

module_file = loadModule('untar', 'master')
include { UNTAR } from "${module_file}"

workflow TEST_UNTAR {
  UNTAR(archive)
}
