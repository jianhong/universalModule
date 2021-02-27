#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.outdir = "./"

testChannel = Channel.fromPath("${workflow.projectDir}/modules/**/test.nf")
indexChannel = Channel.fromPath("${workflow.projectDir}/readme.md")
                      .map{ ["index.html", it ] }
helpChannel = Channel.fromPath("${workflow.projectDir}/modules/**/readme.md")
                     .map{ [it.toString().split('/')[-2]+".html", it ] }
                     .concat(indexChannel)

process TEST {
  input: path(test_file)
  output: path("*.html"), emit: doc
  script:
  """
  nextflow run ${test_file} --docker
  """
}

include { MD_HTML } from './modules/md_html/main' addParams([options: [publish_dir: ".", publish_mode: "copy"]])
workflow {
  testChannel | TEST
  helpChannel | MD_HTML
}

workflow.onComplete {
  log.info ( workflow.success ? "\nDone!": "\nOops..\nSomething went wrong!")
}
