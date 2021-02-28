#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
  loadScriptByName("lib/loadmodule.groovy")
}
this.metaClass.mixin library

params.bam = 'https://raw.githubusercontent.com/jianhong/ribosomeProfilingQC/master/inst/extdata/RPF.KD1.1.bam'
params.outdir = "."

bam = Channel.fromPath(params.bam)
input = bam.map{[[id: "test"], it]}

module_file = loadModule('samtools_sort', 'master')
include { SAMTOOLS_SORT } from "${module_file}"

workflow TEST_SAMTOOLS_SORT {
  SAMTOOLS_SORT(input)
}
