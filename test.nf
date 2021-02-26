#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.outdir = "./"

testChannel = Channel.fromPath("modules/**/test.nf")
helpChannel = Channel.fromPath("./**/readme.md")

process TEST {
  input: path(test_file)
  output: path("*.html"), emit: doc
  script:
  """
  nextflow run ${test_file} --docker
  """
}

include { MD_HTML } from 'modules/md_html/main' addParams([options: [publish_dir: ".", publish_mode: "copy"]])
workflow {
  testChannel | TEST
  helpChannel | MD_HTML
}

workflow.onComplete {
  log.info ( workflow.success ? "\nDone!": "\nOops..\nSomething went wrong!")
}
