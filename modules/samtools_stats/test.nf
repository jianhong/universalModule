#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
  loadScriptByName("lib/loadmodule.groovy")
}
this.metaClass.mixin library

params.bam = 'https://raw.githubusercontent.com/jianhong/ribosomeProfilingQC/master/inst/extdata/RPF.KD1.1.bam'
params.bai = 'https://raw.githubusercontent.com/jianhong/ribosomeProfilingQC/master/inst/extdata/RPF.KD1.1.bai'
params.outdir = "."

bam = Channel.fromPath(params.bam)
bai = Channel.fromPathparams.bai)
input = bam.combine(bai).map{[[id: "test"], it[0], it[1]]}

module_file = loadModule('samtools_stats', 'master')
include { SAMTOOLS_STATS } from "${module_file}"

workflow TEST_SAMTOOLS_STATS {
  SAMTOOLS_STATS(input)
}
