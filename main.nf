#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def options = [:]

log.info """\
NEXTFLOW PIPELINE
=================
input : ${params.input}
outdir: ${params.outdir}
"""

include { CHIPSEQ } from './chipseq' addParams(options: options)
workflow {
  CHIPSEQ()
}

workflow.onComplete {
  log.info ( workflow.success ? "\nDone!": "\nOops..\nSomething went wrong!")
}
