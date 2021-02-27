#!/usr/bin/env nextflow
nextflow.enable.dsl=2

def library = new GroovyScriptEngine('https://raw.githubusercontent.com/jianhong/universalModule/master/').with{
  loadScriptByName("lib/loadmodule.groovy")
}
this.metaClass.mixin library

params.input = "https://raw.githubusercontent.com/jianhong/universalModule/master/modules/md_html/readme.md"
params.outdir = "."

md = Channel.fromPath(params.input).map{["md_html.html", it]}

module_file = loadModule('md_html', 'master')
include { MD_HTML } from "${module_file}"

workflow TEST_MD2HTML {
  MD_HTML(md)
}
