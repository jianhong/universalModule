#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
  loadScriptByName("lib/loadmodule.groovy")
}
this.metaClass.mixin library

new File("samtools.version.txt").withWrite{ writer -> writer.writeLine "0.0.19\n"}

params.input = "samtools.version.txt"
params.outdir = "."

vers = Channel.fromPath(params.input)

module_file = loadModule('session_info', 'master')
include { SESSION_INFO } from "${module_file}"

workflow TEST_SESSION_INFO {
  SESSION_INFO(vers)
}
